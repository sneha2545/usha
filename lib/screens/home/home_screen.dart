import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/patient_scope.dart';
import '../../models/health_category.dart';
import '../../widgets/app_background.dart';
import '../../widgets/usha_bottom_nav.dart';
import '../auth/login_screen.dart';
import '../laboratory/laboratories_screen.dart';
import 'tabs/appointments_tab.dart';
import 'tabs/doctors_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

/// Signed-in application shell with the dashboard and bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _doctorCategory;
  String _doctorQuery = '';
  int _doctorsRequestId = 0;

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _openCategory(HealthCategory category) {
    setState(() {
      _doctorCategory = category.name;
      _doctorQuery = '';
      _doctorsRequestId++;
      _currentIndex = 1;
    });
  }

  void _openDoctorsForSearch(String query) {
    setState(() {
      _doctorCategory = null;
      _doctorQuery = query;
      _doctorsRequestId++;
      _currentIndex = 1;
    });
  }

  void _openLaboratories() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LaboratoriesScreen(),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.signOutTitle),
          content: const Text(AppStrings.signOutBody),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.danger,
                backgroundColor: AppColors.danger.withValues(alpha: 0.08),
              ),
              child: const Text(AppStrings.signOut),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = PatientScope.of(context).patient.fullName;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            HomeTab(
              userName: userName,
              onProfileTap: () => _selectTab(3),
              onCategoryTap: _openCategory,
              onSearchSubmitted: _openDoctorsForSearch,
              onLaboratoryTap: _openLaboratories,
            ),
            DoctorsTab(
              initialCategory: _doctorCategory,
              initialQuery: _doctorQuery,
              requestId: _doctorsRequestId,
            ),
            const AppointmentsTab(),
            ProfileTab(
              onSignOut: _confirmSignOut,
            ),
          ],
        ),
      ),
      bottomNavigationBar: UshaBottomNav(
        currentIndex: _currentIndex,
        onSelected: _selectTab,
      ),
    );
  }
}
