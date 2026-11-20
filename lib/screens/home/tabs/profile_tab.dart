import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/patient_scope.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/patient.dart';
import '../../../widgets/app_surface_card.dart';
import '../../../widgets/profile_appointments_section.dart';
import '../../../widgets/profile_info_section.dart';
import '../../../widgets/section_header.dart';
import '../../profile/edit_profile_screen.dart';

/// Patient profile backed by shared [PatientStore] state, with full personal,
/// health and address details plus appointment history.
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notificationsEnabled = true;

  void _showInfoDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppStrings.done),
            ),
          ],
        );
      },
    );
  }

  void _openEditProfile(Patient patient) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => EditProfileScreen(
          patient: patient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Patient patient = PatientScope.of(context).patient;

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
                  AppStrings.profileTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 27),
                ),
                const SizedBox(height: 16),
                AppSurfaceCard(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brandGradient,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.primaryDeep.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                patient.initials,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  patient.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 19,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  patient.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  patient.mobile,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.verified_user_outlined,
                                        size: 11,
                                        color: AppColors.primaryDeep,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'USHA MEMBER',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontSize: 8.5,
                                              letterSpacing: 0.7,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryDeep,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          key: const Key('profile_edit_button'),
                          onPressed: () => _openEditProfile(patient),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            textStyle: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.primaryDeep,
                          ),
                          label: const Text(AppStrings.editProfile),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ProfileInfoSection(
                  title: AppStrings.personalInformationTitle,
                  icon: Icons.person_outline_rounded,
                  items: <ProfileInfoItem>[
                    ProfileInfoItem(
                      label: AppStrings.fullNameLabel,
                      value: patient.fullName,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.emailLabel,
                      value: patient.email,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.mobileLabel,
                      value: patient.mobile,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.dateOfBirthLabel,
                      value: AppDateFormatter.fullDate(patient.dateOfBirth),
                    ),
                    ProfileInfoItem(
                      label: AppStrings.ageLabel,
                      value: '${patient.age} years',
                    ),
                    ProfileInfoItem(
                      label: AppStrings.genderLabel,
                      value: patient.gender.label,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProfileInfoSection(
                  title: AppStrings.healthProfileTitle,
                  icon: Icons.monitor_heart_outlined,
                  items: <ProfileInfoItem>[
                    ProfileInfoItem(
                      label: AppStrings.bloodGroupLabel,
                      value: patient.bloodGroup,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.heightLabel,
                      value: patient.heightLabel,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.weightLabel,
                      value: patient.weightLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProfileInfoSection(
                  title: AppStrings.addressInformationTitle,
                  icon: Icons.home_outlined,
                  items: <ProfileInfoItem>[
                    ProfileInfoItem(
                      label: AppStrings.houseNumberLabel,
                      value: patient.houseNumber,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.streetLabel,
                      value: patient.street,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.cityLabel,
                      value: patient.city,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.stateLabel,
                      value: patient.state,
                    ),
                    ProfileInfoItem(
                      label: AppStrings.pinCodeLabel,
                      value: patient.pinCode,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: AppStrings.appointmentsTitle),
                const SizedBox(height: 12),
                const ProfileAppointmentsSection(),
                const SizedBox(height: 24),
                Text(
                  'Preferences',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                AppSurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: <Widget>[
                      SwitchListTile.adaptive(
                        key: const Key('profile_notifications_toggle'),
                        value: _notificationsEnabled,
                        onChanged: (bool value) {
                          setState(() => _notificationsEnabled = value);
                        },
                        secondary: const Icon(
                          Icons.notifications_active_outlined,
                          size: 20,
                          color: AppColors.primaryDeep,
                        ),
                        title: Text(
                          'Notifications',
                          style: theme.textTheme.labelMedium,
                        ),
                        subtitle: Text(
                          'Appointment reminders and health tips',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      ListTile(
                        onTap: () => _showInfoDialog(
                          'Help & support',
                          'Our care team is available at support@usha.com '
                              'or on 1800-123-4567, Monday to Saturday.',
                        ),
                        leading: const Icon(
                          Icons.support_agent_rounded,
                          size: 20,
                          color: AppColors.primaryDeep,
                        ),
                        title: Text(
                          'Help & support',
                          style: theme.textTheme.labelMedium,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      ListTile(
                        onTap: () => _showInfoDialog(
                          'About USHA',
                          'USHA is a preventive healthcare experience built '
                              'around you. Your Health, Our Priority.\n\n'
                              'Version 1.0.0',
                        ),
                        leading: const Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: AppColors.primaryDeep,
                        ),
                        title: Text(
                          'About USHA',
                          style: theme.textTheme.labelMedium,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('profile_sign_out_button'),
                    onPressed: widget.onSignOut,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.25),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(AppStrings.signOut),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
