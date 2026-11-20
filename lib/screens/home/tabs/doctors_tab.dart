import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/demo_data.dart';
import '../../../models/doctor.dart';
import '../../../models/health_category.dart';
import '../../../widgets/doctor_card.dart';
import '../../../widgets/doctor_details_sheet.dart';
import '../../../widgets/usha_search_field.dart';

/// Searchable doctor directory with speciality filters.
class DoctorsTab extends StatefulWidget {
  const DoctorsTab({
    super.key,
    this.initialCategory,
    this.initialQuery,
    this.requestId = 0,
  });

  final String? initialCategory;
  final String? initialQuery;
  final int requestId;

  @override
  State<DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<DoctorsTab> {
  late final TextEditingController _searchController;
  String? _category;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _query = widget.initialQuery ?? '';
    _searchController = TextEditingController(text: _query);
  }

  @override
  void didUpdateWidget(covariant DoctorsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId != widget.requestId) {
      setState(() {
        _category = widget.initialCategory;
        _query = widget.initialQuery ?? '';
        _searchController.text = _query;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> get _filteredDoctors {
    final String query = _query.trim().toLowerCase();
    return DemoData.doctors.where((Doctor doctor) {
      final bool matchesQuery =
          query.isEmpty ||
          doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);
      final bool matchesCategory =
          _category == null || doctor.specialty == _category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Doctor> doctors = _filteredDoctors;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.doctorsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 27),
                ),
                const SizedBox(height: 5),
                Text(
                  AppStrings.doctorsSubtitle,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                UshaSearchField(
                  key: const Key('doctors_search_field'),
                  controller: _searchController,
                  hintText: AppStrings.searchHint,
                  onChanged: (String value) {
                    setState(() => _query = value);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      _FilterChip(
                        key: const Key('doctor_filter_all'),
                        label: AppStrings.allCategories,
                        isSelected: _category == null,
                        onTap: () => setState(() => _category = null),
                      ),
                      for (final HealthCategory category
                          in DemoData.categories)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _FilterChip(
                            key: Key('doctor_filter_${category.name}'),
                            label: category.name,
                            isSelected: _category == category.name,
                            onTap: () =>
                                setState(() => _category = category.name),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${doctors.length} specialist'
                  '${doctors.length == 1 ? '' : 's'} available',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (doctors.isEmpty)
                  _buildEmptyState(theme)
                else
                  for (final Doctor doctor in doctors)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DoctorCard(
                        key: Key('directory_doctor_${doctor.id}'),
                        doctor: doctor,
                        onViewProfile: () =>
                            showDoctorDetails(context, doctor),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.search_off_rounded,
            size: 30,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(AppStrings.noDoctorsFound, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            AppStrings.noDoctorsHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
