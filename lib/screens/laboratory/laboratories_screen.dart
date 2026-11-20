import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/demo_data.dart';
import '../../models/laboratory.dart';
import '../../widgets/app_surface_card.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/usha_search_field.dart';
import 'laboratory_details_screen.dart';

/// Searchable directory of fictional USHA demo laboratories.
class LaboratoriesScreen extends StatefulWidget {
  const LaboratoriesScreen({super.key});

  @override
  State<LaboratoriesScreen> createState() => _LaboratoriesScreenState();
}

class _LaboratoriesScreenState extends State<LaboratoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Laboratory> get _filteredLaboratories {
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return DemoData.laboratories;
    }

    return DemoData.laboratories.where((Laboratory laboratory) {
      return laboratory.name.toLowerCase().contains(query) ||
          laboratory.address.toLowerCase().contains(query) ||
          laboratory.locality.toLowerCase().contains(query) ||
          laboratory.city.toLowerCase().contains(query);
    }).toList();
  }

  void _openLaboratory(Laboratory laboratory) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            LaboratoryDetailsScreen(laboratory: laboratory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Laboratory> laboratories = _filteredLaboratories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.laboratoriesTitle)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.laboratoriesSubtitle,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  UshaSearchField(
                    key: const Key('laboratory_search_field'),
                    controller: _searchController,
                    hintText: AppStrings.laboratorySearchHint,
                    onChanged: (String value) {
                      setState(() => _query = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppColors.primaryDeep,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.demoDataNotice,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (DemoData.laboratories.isEmpty)
                    const EmptyStateCard(
                      key: Key('laboratory_empty_state'),
                      icon: Icons.biotech_outlined,
                      title: AppStrings.noLaboratoriesAvailable,
                      message: AppStrings.noLaboratoriesAvailableHint,
                    )
                  else if (laboratories.isEmpty)
                    const EmptyStateCard(
                      key: Key('laboratory_no_results'),
                      icon: Icons.search_off_rounded,
                      title: AppStrings.noLaboratoriesFound,
                      message: AppStrings.noLaboratoriesHint,
                    )
                  else
                    for (final Laboratory laboratory in laboratories)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LaboratoryCard(
                          key: Key('laboratory_${laboratory.id}'),
                          laboratory: laboratory,
                          onTap: () => _openLaboratory(laboratory),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LaboratoryCard extends StatelessWidget {
  const _LaboratoryCard({
    super.key,
    required this.laboratory,
    required this.onTap,
  });

  final Laboratory laboratory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color collectionColor = laboratory.supportsHomeSampleCollection
        ? AppColors.success
        : AppColors.textSecondary;

    return AppSurfaceCard(
      onTap: onTap,
      radius: 18,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.biotech_outlined,
                  color: AppColors.primaryDeep,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      laboratory.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            laboratory.locationLabel,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.schedule_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  laboratory.operatingHours,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: collectionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      laboratory.supportsHomeSampleCollection
                          ? Icons.home_outlined
                          : Icons.location_city_outlined,
                      size: 14,
                      color: collectionColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        laboratory.supportsHomeSampleCollection
                            ? AppStrings.homeCollectionAvailable
                            : AppStrings.homeCollectionUnavailable,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: collectionColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
