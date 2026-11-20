import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/diagnostic_test.dart';
import '../../models/health_checkup_package.dart';
import '../../models/lab_booking.dart';
import '../../models/laboratory.dart';
import '../../widgets/app_surface_card.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/lab_booking_sheet.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';
import '../../widgets/usha_search_field.dart';

/// Displays a laboratory's local catalog of tests and health packages.
class LaboratoryDetailsScreen extends StatefulWidget {
  const LaboratoryDetailsScreen({super.key, required this.laboratory});

  final Laboratory laboratory;

  @override
  State<LaboratoryDetailsScreen> createState() =>
      _LaboratoryDetailsScreenState();
}

class _LaboratoryDetailsScreenState extends State<LaboratoryDetailsScreen> {
  final TextEditingController _testSearchController = TextEditingController();
  String _testQuery = '';

  Laboratory get _laboratory => widget.laboratory;

  List<DiagnosticTest> get _filteredTests {
    final String query = _testQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _laboratory.tests;
    }

    return _laboratory.tests
        .where((DiagnosticTest test) => test.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _testSearchController.dispose();
    super.dispose();
  }

  List<DiagnosticTest> _includedTests(HealthCheckupPackage package) {
    return _laboratory.tests
        .where(
          (DiagnosticTest test) => package.includedTestIds.contains(test.id),
        )
        .toList();
  }

  Future<void> _showTestDetails(DiagnosticTest test) async {
    final bool? shouldBook = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => _CatalogDetailsSheet(
        icon: Icons.biotech_outlined,
        title: test.name,
        price: test.priceLabel,
        description:
            test.preparationInstructions ?? AppStrings.noPreparationRequired,
        descriptionLabel: AppStrings.preparationLabel,
        buttonLabel: AppStrings.bookThisTest,
        onBook: () => Navigator.of(context).pop(true),
      ),
    );
    if (shouldBook == true && mounted) {
      await showLabBookingSheet(
        context,
        laboratory: _laboratory,
        service: LabBookingService(
          type: LabBookingServiceType.diagnosticTest,
          id: test.id,
          name: test.name,
          price: test.price,
        ),
      );
    }
  }

  Future<void> _showPackageDetails(HealthCheckupPackage package) async {
    final List<DiagnosticTest> includedTests = _includedTests(package);
    final bool? shouldBook = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => _PackageDetailsSheet(
        package: package,
        includedTests: includedTests,
        onBook: () => Navigator.of(context).pop(true),
      ),
    );
    if (shouldBook == true && mounted) {
      await showLabBookingSheet(
        context,
        laboratory: _laboratory,
        service: LabBookingService(
          type: LabBookingServiceType.healthPackage,
          id: package.id,
          name: package.name,
          price: package.price,
          includedTestNames: includedTests
              .map((DiagnosticTest test) => test.name)
              .toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<DiagnosticTest> tests = _filteredTests;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.laboratoryDetailsTitle)),
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
                  _LaboratoryOverviewCard(laboratory: _laboratory),
                  const SizedBox(height: 22),
                  const SectionHeader(title: AppStrings.diagnosticTestsTitle),
                  const SizedBox(height: 10),
                  UshaSearchField(
                    key: const Key('diagnostic_test_search_field'),
                    controller: _testSearchController,
                    hintText: AppStrings.testSearchHint,
                    onChanged: (String value) {
                      setState(() => _testQuery = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (tests.isEmpty)
                    const EmptyStateCard(
                      key: Key('diagnostic_test_no_results'),
                      icon: Icons.search_off_rounded,
                      title: AppStrings.noTestsFound,
                      message: AppStrings.noTestsHint,
                    )
                  else
                    for (final DiagnosticTest test in tests)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DiagnosticTestCard(
                          key: Key('diagnostic_test_${test.id}'),
                          test: test,
                          onViewDetails: () => _showTestDetails(test),
                        ),
                      ),
                  const SizedBox(height: 16),
                  const SectionHeader(title: AppStrings.healthPackagesTitle),
                  const SizedBox(height: 10),
                  if (_laboratory.packages.isEmpty)
                    const EmptyStateCard(
                      key: Key('health_packages_empty'),
                      icon: Icons.health_and_safety_outlined,
                      title: 'No health packages available',
                      message:
                          'Check back later for packages offered by this lab.',
                    )
                  else
                    for (final HealthCheckupPackage package
                        in _laboratory.packages)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _HealthPackageCard(
                          key: Key('health_package_${package.id}'),
                          package: package,
                          includedTestCount: _includedTests(package).length,
                          onViewDetails: () => _showPackageDetails(package),
                        ),
                      ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.demoDataNotice,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
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

class _LaboratoryOverviewCard extends StatelessWidget {
  const _LaboratoryOverviewCard({required this.laboratory});

  final Laboratory laboratory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color collectionColor = laboratory.supportsHomeSampleCollection
        ? AppColors.success
        : AppColors.textSecondary;

    return AppSurfaceCard(
      radius: 20,
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.biotech_outlined,
                  color: AppColors.primaryDeep,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  laboratory.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _OverviewLine(
            icon: Icons.location_on_outlined,
            text: '${laboratory.address}, ${laboratory.locationLabel}',
          ),
          const SizedBox(height: 9),
          _OverviewLine(
            icon: Icons.schedule_rounded,
            text:
                '${AppStrings.operatingHoursLabel}: '
                '${laboratory.operatingHours}',
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: collectionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  laboratory.supportsHomeSampleCollection
                      ? Icons.home_outlined
                      : Icons.location_city_outlined,
                  size: 15,
                  color: collectionColor,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    laboratory.supportsHomeSampleCollection
                        ? AppStrings.homeCollectionAvailable
                        : AppStrings.homeCollectionUnavailable,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: collectionColor,
                      fontSize: 10,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewLine extends StatelessWidget {
  const _OverviewLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _DiagnosticTestCard extends StatelessWidget {
  const _DiagnosticTestCard({
    super.key,
    required this.test,
    required this.onViewDetails,
  });

  final DiagnosticTest test;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppSurfaceCard(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.science_outlined,
              size: 19,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  test.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (test.preparationInstructions != null) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    test.preparationInstructions!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                test.priceLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                key: Key('test_details_${test.id}'),
                onPressed: onViewDetails,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  AppStrings.viewTestDetails,
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthPackageCard extends StatelessWidget {
  const _HealthPackageCard({
    super.key,
    required this.package,
    required this.includedTestCount,
    required this.onViewDetails,
  });

  final HealthCheckupPackage package;
  final int includedTestCount;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppSurfaceCard(
      radius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  package.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                package.priceLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(package.description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 5),
          Text(
            '$includedTestCount included tests',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.secondary,
              letterSpacing: 0,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: Key('package_details_${package.id}'),
              onPressed: onViewDetails,
              child: const Text(AppStrings.viewPackageDetails),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogDetailsSheet extends StatelessWidget {
  const _CatalogDetailsSheet({
    required this.icon,
    required this.title,
    required this.price,
    required this.description,
    required this.descriptionLabel,
    required this.buttonLabel,
    required this.onBook,
  });

  final IconData icon;
  final String title;
  final String price;
  final String description;
  final String descriptionLabel;
  final String buttonLabel;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Text(descriptionLabel, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 18),
            PrimaryButton(
              key: const Key('lab_test_book_button'),
              label: buttonLabel,
              onPressed: onBook,
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageDetailsSheet extends StatelessWidget {
  const _PackageDetailsSheet({
    required this.package,
    required this.includedTests,
    required this.onBook,
  });

  final HealthCheckupPackage package;
  final List<DiagnosticTest> includedTests;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(package.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              package.priceLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(package.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              AppStrings.includedTestsLabel,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 7),
            for (final DiagnosticTest test in includedTests)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(test.name, style: theme.textTheme.bodySmall),
                    ),
                    Text(
                      test.priceLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            PrimaryButton(
              key: const Key('lab_package_book_button'),
              label: AppStrings.bookThisPackage,
              onPressed: onBook,
            ),
          ],
        ),
      ),
    );
  }
}
