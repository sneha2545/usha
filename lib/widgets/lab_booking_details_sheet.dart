import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/state/lab_booking_scope.dart';
import '../core/state/lab_booking_store.dart';
import '../core/utils/date_formatter.dart';
import '../models/lab_booking.dart';
import 'app_surface_card.dart';
import 'primary_button.dart';

/// Opens the read-only lab booking details and cancellation sheet.
Future<void> showLabBookingDetails(BuildContext context, LabBooking booking) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) =>
        LabBookingDetailsSheet(booking: booking),
  );
}

class LabBookingDetailsSheet extends StatelessWidget {
  const LabBookingDetailsSheet({super.key, required this.booking});

  final LabBooking booking;

  Future<void> _cancel(BuildContext context, LabBookingStore store) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text(AppStrings.cancelAppointmentTitle),
        content: Text(
          'Cancel the laboratory booking at '
          '${booking.laboratoryName}?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.keepAppointment),
          ),
          TextButton(
            key: const Key('lab_booking_cancel_confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text(AppStrings.cancelAppointment),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final bool cancelled = store.cancel(booking.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cancelled
              ? AppStrings.bookingCancelled
              : 'This laboratory booking is no longer active.',
        ),
      ),
    );
    if (cancelled) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LabBookingStore store = LabBookingScope.of(context);
    final bool canCancel =
        booking.status == LabBookingStatus.confirmed &&
        booking.scheduledAt.isAfter(store.currentTime);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.labBookingDetailsTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              AppSurfaceCard(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _DetailLine(
                      label: AppStrings.laboratoryDetailsTitle,
                      value: booking.laboratoryName,
                    ),
                    _DetailLine(
                      label: 'Location',
                      value: booking.laboratoryLocation,
                    ),
                    _DetailLine(
                      label: booking.serviceType.label,
                      value: booking.serviceName,
                    ),
                    if (booking.includedTestNames.isNotEmpty)
                      _DetailLine(
                        label: AppStrings.includedTestsLabel,
                        value: booking.includedTestNames.join(', '),
                      ),
                    _DetailLine(
                      label: 'Date',
                      value: AppDateFormatter.fullDate(booking.scheduledAt),
                    ),
                    _DetailLine(
                      label: 'Time',
                      value: AppDateFormatter.time(booking.scheduledAt),
                    ),
                    _DetailLine(
                      label: AppStrings.labCollectionMethodLabel,
                      value: booking.collectionMethod.label,
                    ),
                    if (booking.collectionAddress != null)
                      _DetailLine(
                        label: AppStrings.labHomeAddressLabel,
                        value: booking.collectionAddress!,
                      ),
                    _DetailLine(label: 'Price', value: booking.priceLabel),
                    _DetailLine(
                      label: AppStrings.bookingStatusLabel,
                      value: booking.status.label,
                      valueColor: booking.status == LabBookingStatus.cancelled
                          ? AppColors.danger
                          : booking.status == LabBookingStatus.completed
                          ? AppColors.success
                          : AppColors.primaryDeep,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (canCancel)
                PrimaryButton(
                  key: const Key('lab_booking_cancel_button'),
                  label: AppStrings.cancelAppointment,
                  onPressed: () => _cancel(context, store),
                )
              else
                PrimaryButton(
                  label: AppStrings.done,
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
