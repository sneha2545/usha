import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/state/appointment_scope.dart';
import '../../../models/doctor.dart';
import '../../../models/health_category.dart';
import '../../../models/appointment.dart';
import '../../../widgets/appointment_card.dart';
import '../../../widgets/appointment_details_sheet.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/booking_sheet.dart';
import '../../../widgets/category_card.dart';
import '../../../widgets/doctor_card.dart';
import '../../../widgets/doctor_details_sheet.dart';
import '../../../widgets/empty_state_card.dart';
import '../../../widgets/notifications_sheet.dart';
import '../../../widgets/promo_banner.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/usha_search_field.dart';

/// Home dashboard content: header, search, banner, categories, appointment
/// and popular doctors.
class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.userName,
    required this.onProfileTap,
    required this.onCategoryTap,
    required this.onSearchSubmitted,
    required this.onLaboratoryTap,
  });

  final String userName;
  final VoidCallback onProfileTap;
  final ValueChanged<HealthCategory> onCategoryTap;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onLaboratoryTap;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _firstName {
    final List<String> parts = widget.userName
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? 'there' : parts.first;
  }

  String get _initials {
    final List<String> parts = widget.userName
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'U';
    }
    return parts
        .take(2)
        .map((String part) => part[0].toUpperCase())
        .join();
  }

  List<Doctor> get _visibleDoctors {
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return DemoData.popularDoctors;
    }
    return DemoData.doctors.where((Doctor doctor) {
      return doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);
    }).toList();
  }

  void _openDoctor(Doctor doctor) {
    showDoctorDetails(context, doctor);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isSearching = _query.trim().isNotEmpty;
    final List<Doctor> doctors = _visibleDoctors;
    final List<Appointment> upcomingAppointments =
        AppointmentScope.of(context).upcoming;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(theme),
                const SizedBox(height: 24),
                Text(
                  AppStrings.helloWelcome,
                  style: theme.textTheme.headlineLarge?.copyWith(fontSize: 29),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_firstName, let\'s take care of your health today.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                UshaSearchField(
                  key: const Key('home_search_field'),
                  controller: _searchController,
                  hintText: AppStrings.searchHint,
                  onChanged: (String value) {
                    setState(() => _query = value);
                  },
                  onSubmitted: widget.onSearchSubmitted,
                ),
                const SizedBox(height: 20),
                PromoBanner(
                  onBook: () => showBookingSheet(context),
                  onExploreLaboratory: widget.onLaboratoryTap,
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: AppStrings.categoriesTitle),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    const double gap = 12;
                    final double cardWidth =
                        (constraints.maxWidth - gap * 2) / 3;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: <Widget>[
                        for (final HealthCategory category
                            in DemoData.categories)
                          SizedBox(
                            width: cardWidth,
                            height: 106,
                            child: CategoryCard(
                              key: Key('category_${category.name}'),
                              category: category,
                              onTap: () => widget.onCategoryTap(category),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: AppStrings.upcomingAppointmentTitle,
                ),
                const SizedBox(height: 12),
                if (upcomingAppointments.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.event_available_outlined,
                    title: AppStrings.emptyUpcomingTitle,
                    message: AppStrings.emptyUpcomingBody,
                  )
                else
                  AppointmentCard(
                    appointment: upcomingAppointments.first,
                    onViewDetails: () => showAppointmentDetails(
                      context,
                      upcomingAppointments.first,
                    ),
                  ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: isSearching
                      ? 'Search results'
                      : AppStrings.popularDoctorsTitle,
                ),
                const SizedBox(height: 12),
                if (doctors.isEmpty)
                  _buildEmptyState(theme)
                else
                  for (final Doctor doctor in doctors)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DoctorCard(
                        key: Key('home_doctor_${doctor.id}'),
                        doctor: doctor,
                        onViewProfile: () => _openDoctor(doctor),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: <Widget>[
        const AppLogo(size: 40, showShadow: false),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.appName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 3.6,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'HEALTHCARE',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 8,
                letterSpacing: 2.2,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            IconButton(
              key: const Key('home_notifications'),
              onPressed: () => showNotificationsSheet(context),
              tooltip: AppStrings.notificationsTitle,
              style: IconButton.styleFrom(
                fixedSize: const Size(42, 42),
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
              ),
              icon: const Icon(Icons.notifications_none_rounded, size: 19),
            ),
            Positioned(
              top: 8,
              right: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('home_profile_avatar'),
            onTap: widget.onProfileTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.brandGradient,
                border: Border.all(
                  color: AppColors.surface,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
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
