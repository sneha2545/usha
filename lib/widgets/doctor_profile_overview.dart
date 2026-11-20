import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/doctor.dart';
import 'app_surface_card.dart';
import 'doctor_avatar.dart';
import 'section_header.dart';

/// Shared doctor information used in profile and appointment details.
class DoctorProfileOverview extends StatelessWidget {
  const DoctorProfileOverview({super.key, required this.doctor});

  final Doctor doctor;

  String? _nonEmpty(String? value) {
    final String? trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? qualification = _nonEmpty(doctor.qualification);
    final String? clinic = _nonEmpty(doctor.clinic);
    final String? clinicLocation = _nonEmpty(doctor.clinicLocation);
    final String? availability = _nonEmpty(doctor.availabilityInfo);
    final String biography = _nonEmpty(doctor.about) ??
        AppStrings.doctorBioUnavailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSurfaceCard(
          radius: 20,
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          color: AppColors.primarySoft.withValues(alpha: 0.45),
          child: Column(
            children: <Widget>[
              DoctorAvatar(
                key: Key('doctor_profile_avatar_${doctor.id}'),
                doctor: doctor,
                size: 116,
                showBadge: false,
              ),
              const SizedBox(height: 14),
              Text(
                doctor.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 21),
              ),
              const SizedBox(height: 5),
              Text(
                doctor.specialty,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (qualification != null) ...<Widget>[
                const SizedBox(height: 5),
                Text(
                  qualification,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 9,
                runSpacing: 8,
                children: <Widget>[
                  _ProfileFact(
                    icon: Icons.work_history_outlined,
                    label: '${doctor.experienceYears} years experience',
                  ),
                  _ProfileFact(
                    icon: Icons.star_outline_rounded,
                    label:
                        '${doctor.rating.toStringAsFixed(1)} '
                        '(${doctor.reviewCount} reviews)',
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!doctor.isVerified) ...<Widget>[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.doctorProfileDemoNotice,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        AppSurfaceCard(
          radius: 18,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (clinic != null)
                _ProfileInfoRow(
                  icon: Icons.local_hospital_outlined,
                  label: AppStrings.clinicLabel,
                  value: clinic,
                ),
              if (clinic != null && clinicLocation != null)
                const SizedBox(height: 12),
              if (clinicLocation != null)
                _ProfileInfoRow(
                  icon: Icons.location_on_outlined,
                  label: AppStrings.clinicLocationLabel,
                  value: clinicLocation,
                ),
              if ((clinic != null || clinicLocation != null) &&
                  availability != null)
                const SizedBox(height: 12),
              if (availability != null)
                _ProfileInfoRow(
                  icon: Icons.schedule_rounded,
                  label: AppStrings.availabilityLabel,
                  value: availability,
                ),
              if (clinic != null ||
                  clinicLocation != null ||
                  availability != null)
                const SizedBox(height: 12),
              _ProfileInfoRow(
                icon: Icons.payments_outlined,
                label: AppStrings.consultationFeeLabel,
                value: doctor.feeLabel,
              ),
              if (doctor.languages.isNotEmpty) ...<Widget>[
                const SizedBox(height: 13),
                Text(
                  AppStrings.languagesSpokenLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: doctor.languages
                      .map(
                        (String language) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            language,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textPrimary,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(title: AppStrings.aboutDoctorLabel),
        const SizedBox(height: 9),
        AppSurfaceCard(
          radius: 18,
          padding: const EdgeInsets.all(15),
          child: Text(
            biography,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.primaryDeep),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9.5,
              color: AppColors.primaryDeep,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 17, color: AppColors.primaryDeep),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
