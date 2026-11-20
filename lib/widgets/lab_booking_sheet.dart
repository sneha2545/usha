import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/state/lab_booking_scope.dart';
import '../core/state/lab_booking_store.dart';
import '../core/state/patient_scope.dart';
import '../core/utils/date_formatter.dart';
import '../core/utils/validators.dart';
import '../models/lab_booking.dart';
import '../models/laboratory.dart';
import 'app_surface_card.dart';
import 'primary_button.dart';

/// Opens the lab booking flow and saves the confirmed local booking.
Future<void> showLabBookingSheet(
  BuildContext context, {
  required Laboratory laboratory,
  required LabBookingService service,
}) async {
  final LabBookingStore store = LabBookingScope.of(context);
  final LabBooking? booking = await showModalBottomSheet<LabBooking>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) =>
        LabBookingSheet(laboratory: laboratory, service: service),
  );

  if (booking == null || !context.mounted) {
    return;
  }

  final bool saved = store.addBooking(booking);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        saved
            ? AppStrings.labBookingSuccess
            : AppStrings.labBookingSlotUnavailable,
      ),
    ),
  );
}

/// Local booking review for one diagnostic test or health package.
class LabBookingSheet extends StatefulWidget {
  const LabBookingSheet({
    super.key,
    required this.laboratory,
    required this.service,
  });

  final Laboratory laboratory;
  final LabBookingService service;

  @override
  State<LabBookingSheet> createState() => _LabBookingSheetState();
}

class _LabBookingSheetState extends State<LabBookingSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  late final List<DateTime> _dates;
  bool _dependenciesInitialized = false;
  bool _isSubmitting = false;
  int _selectedDateIndex = 0;
  DateTime? _selectedSlot;
  LabCollectionMethod _collectionMethod = LabCollectionMethod.labVisit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesInitialized) {
      return;
    }

    final LabBookingStore store = LabBookingScope.of(context);
    final DateTime today = store.currentTime;
    _dates = List<DateTime>.generate(
      3,
      (int index) => DateTime(today.year, today.month, today.day + index),
    );

    final patient = PatientScope.of(context).patient;
    _houseController.text = patient.houseNumber;
    _streetController.text = patient.street;
    _cityController.text = patient.city;
    _stateController.text = patient.state;
    _pinController.text = patient.pinCode;

    _selectedDateIndex = _firstAvailableDateIndex(store);
    _selectedSlot = _firstAvailableSlot(store, _dates[_selectedDateIndex]);
    _dependenciesInitialized = true;
  }

  @override
  void dispose() {
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  int _firstAvailableDateIndex(LabBookingStore store) {
    for (int index = 0; index < _dates.length; index++) {
      if (_firstAvailableSlot(store, _dates[index]) != null) {
        return index;
      }
    }
    return 0;
  }

  DateTime? _firstAvailableSlot(LabBookingStore store, DateTime date) {
    for (final DateTime slot in store.slotsForDate(
      widget.laboratory.id,
      date,
    )) {
      if (store.isSlotAvailable(widget.laboratory.id, slot)) {
        return slot;
      }
    }
    return null;
  }

  String _addressSnapshot() {
    final String cityState =
        '${_cityController.text.trim()}, ${_stateController.text.trim()} '
        '${_pinController.text.trim()}';
    return '${_houseController.text.trim()}, '
        '${_streetController.text.trim()}\n$cityState';
  }

  void _selectDate(LabBookingStore store, int index) {
    setState(() {
      _selectedDateIndex = index;
      _selectedSlot = _firstAvailableSlot(store, _dates[index]);
    });
  }

  void _confirmBooking(LabBookingStore store) {
    if (_isSubmitting) {
      return;
    }
    if (_collectionMethod == LabCollectionMethod.homeCollection &&
        !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final DateTime? scheduledAt = _selectedSlot;
    if (scheduledAt == null ||
        !store.isSlotAvailable(widget.laboratory.id, scheduledAt)) {
      setState(() => _selectedSlot = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.labBookingSlotUnavailable)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final DateTime createdAt = store.currentTime;
    final LabBooking booking = LabBooking(
      id:
          'lab-${widget.laboratory.id}-${widget.service.id}-'
          '${DateTime.now().microsecondsSinceEpoch}',
      laboratoryId: widget.laboratory.id,
      laboratoryName: widget.laboratory.name,
      laboratoryLocation:
          '${widget.laboratory.address}, ${widget.laboratory.locationLabel}',
      serviceType: widget.service.type,
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      price: widget.service.price,
      includedTestNames: widget.service.includedTestNames,
      scheduledAt: scheduledAt,
      collectionMethod: _collectionMethod,
      collectionAddress: _collectionMethod == LabCollectionMethod.homeCollection
          ? _addressSnapshot()
          : null,
      status: LabBookingStatus.confirmed,
      createdAt: createdAt,
    );
    Navigator.of(context).pop(booking);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LabBookingStore store = LabBookingScope.of(context);
    final DateTime? selectedSlot = _selectedSlot;
    final bool selectedSlotAvailable =
        selectedSlot != null &&
        store.isSlotAvailable(widget.laboratory.id, selectedSlot);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppStrings.labBookingTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  _BookingSummaryCard(
                    laboratory: widget.laboratory,
                    service: widget.service,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.labCollectionMethodLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 9,
                    runSpacing: 8,
                    children: <Widget>[
                      ChoiceChip(
                        key: const Key('lab_collection_lab_visit'),
                        avatar: const Icon(
                          Icons.location_city_outlined,
                          size: 17,
                        ),
                        label: const Text(AppStrings.labVisitLabel),
                        selected:
                            _collectionMethod == LabCollectionMethod.labVisit,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(
                              () => _collectionMethod =
                                  LabCollectionMethod.labVisit,
                            );
                          }
                        },
                      ),
                      ChoiceChip(
                        key: const Key('lab_collection_home'),
                        avatar: const Icon(Icons.home_outlined, size: 17),
                        label: const Text(AppStrings.homeCollectionLabel),
                        selected:
                            _collectionMethod ==
                            LabCollectionMethod.homeCollection,
                        onSelected:
                            widget.laboratory.supportsHomeSampleCollection
                            ? (bool selected) {
                                if (selected) {
                                  setState(
                                    () => _collectionMethod =
                                        LabCollectionMethod.homeCollection,
                                  );
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                  if (!widget
                      .laboratory
                      .supportsHomeSampleCollection) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.homeCollectionUnavailableForLab,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (_collectionMethod == LabCollectionMethod.homeCollection)
                    _buildAddressFields(theme),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.chooseDate,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: <Widget>[
                      for (
                        int index = 0;
                        index < _dates.length;
                        index++
                      ) ...<Widget>[
                        if (index > 0) const SizedBox(width: 8),
                        Expanded(child: _buildDateChoice(store, theme, index)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    AppStrings.chooseTime,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 9),
                  _buildTimeChoices(store, theme),
                  const SizedBox(height: 18),
                  _buildReviewCard(theme, store),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    key: const Key('lab_booking_confirm_button'),
                    label: AppStrings.confirmLabBooking,
                    onPressed: selectedSlotAvailable && !_isSubmitting
                        ? () => _confirmBooking(store)
                        : null,
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: AppSurfaceCard(
        radius: 16,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.labHomeAddressLabel,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            _addressField(
              key: const Key('lab_address_house'),
              controller: _houseController,
              label: AppStrings.houseNumberLabel,
            ),
            const SizedBox(height: 9),
            _addressField(
              key: const Key('lab_address_street'),
              controller: _streetController,
              label: AppStrings.streetLabel,
            ),
            const SizedBox(height: 9),
            _addressField(
              key: const Key('lab_address_city'),
              controller: _cityController,
              label: AppStrings.cityLabel,
            ),
            const SizedBox(height: 9),
            _addressField(
              key: const Key('lab_address_state'),
              controller: _stateController,
              label: AppStrings.stateLabel,
            ),
            const SizedBox(height: 9),
            _addressField(
              key: const Key('lab_address_pin'),
              controller: _pinController,
              label: AppStrings.pinCodeLabel,
              keyboardType: TextInputType.number,
              validator: Validators.pinCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressField({
    required Key key,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (String? value) => Validators.requiredField(
            value,
            message: AppStrings.labAddressRequired,
          ),
    );
  }

  Widget _buildDateChoice(LabBookingStore store, ThemeData theme, int index) {
    final DateTime date = _dates[index];
    final bool hasAvailableSlot = store
        .slotsForDate(widget.laboratory.id, date)
        .any(
          (DateTime slot) => store.isSlotAvailable(widget.laboratory.id, slot),
        );
    final bool selected = _selectedDateIndex == index;
    final String dayLabel = index == 0
        ? 'Today'
        : index == 1
        ? 'Tomorrow'
        : AppDateFormatter.weekdayShort(date);

    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: Key('lab_booking_date_$index'),
        borderRadius: BorderRadius.circular(12),
        onTap: hasAvailableSlot ? () => _selectDate(store, index) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Column(
            children: <Widget>[
              Text(
                dayLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: hasAvailableSlot
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 0,
                ),
              ),
              Text(
                AppDateFormatter.dayMonth(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: hasAvailableSlot
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChoices(LabBookingStore store, ThemeData theme) {
    final List<DateTime> slots = store.slotsForDate(
      widget.laboratory.id,
      _dates[_selectedDateIndex],
    );
    if (slots.isEmpty) {
      return Text(
        AppStrings.labNoSlotsAvailable,
        style: theme.textTheme.bodySmall,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final DateTime slot in slots)
          ChoiceChip(
            key: Key('lab_booking_slot_${slot.hour}_${slot.minute}'),
            label: Text(AppDateFormatter.time(slot)),
            selected: _selectedSlot == slot,
            onSelected: store.isSlotAvailable(widget.laboratory.id, slot)
                ? (_) => setState(() => _selectedSlot = slot)
                : null,
          ),
      ],
    );
  }

  Widget _buildReviewCard(ThemeData theme, LabBookingStore store) {
    final DateTime? slot = _selectedSlot;
    final String collectionDetails =
        _collectionMethod == LabCollectionMethod.labVisit
        ? AppStrings.labVisitLabel
        : '${AppStrings.homeCollectionLabel}\n${_addressSnapshot()}';

    return AppSurfaceCard(
      key: const Key('lab_booking_review'),
      radius: 16,
      color: AppColors.primarySoft.withValues(alpha: 0.55),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.labBookingReviewTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _ReviewLine(
            label: AppStrings.laboratoryDetailsTitle,
            value: widget.laboratory.name,
          ),
          _ReviewLine(
            label: AppStrings.labSelectedServiceLabel,
            value: '${widget.service.name} · ${widget.service.type.label}',
          ),
          _ReviewLine(
            label: AppStrings.labCollectionMethodLabel,
            value: collectionDetails,
          ),
          _ReviewLine(
            label: 'Date and time',
            value: slot == null
                ? AppStrings.labNoSlotsAvailable
                : '${AppDateFormatter.fullDate(slot)} · '
                      '${AppDateFormatter.time(slot)}',
          ),
          _ReviewLine(
            label: 'Total listed price',
            value: '₹${widget.service.price}',
          ),
          if (slot != null)
            _ReviewLine(
              label: 'Slot capacity',
              value:
                  '${store.reservationsForSlot(widget.laboratory.id, slot)}'
                  ' of ${store.capacityForSlot(widget.laboratory.id, slot)} '
                  'reserved',
            ),
        ],
      ),
    );
  }
}

class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({required this.laboratory, required this.service});

  final Laboratory laboratory;
  final LabBookingService service;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppSurfaceCard(
      radius: 16,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            laboratory.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${laboratory.address}, ${laboratory.locationLabel}',
            style: theme.textTheme.bodySmall,
          ),
          const Divider(height: 18),
          Text(service.type.label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 3),
          Text(service.name, style: theme.textTheme.labelMedium),
          if (service.includedTestNames.isNotEmpty) ...<Widget>[
            const SizedBox(height: 7),
            Text(
              '${AppStrings.includedTestsLabel}: '
              '${service.includedTestNames.join(', ')}',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '₹${service.price}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
