import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Custom floating-style bottom navigation for the dashboard shell.
class UshaBottomNav extends StatelessWidget {
  const UshaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const List<_NavDestination> _destinations = <_NavDestination>[
    _NavDestination(
      label: AppStrings.navHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      keyName: 'nav_home',
    ),
    _NavDestination(
      label: AppStrings.navDoctors,
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services_rounded,
      keyName: 'nav_doctors',
    ),
    _NavDestination(
      label: AppStrings.navAppointments,
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      keyName: 'nav_appointments',
    ),
    _NavDestination(
      label: AppStrings.navProfile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      keyName: 'nav_profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.9)),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
          child: Row(
            children: <Widget>[
              for (int index = 0; index < _destinations.length; index++)
                Expanded(
                  child: _NavItem(
                    destination: _destinations[index],
                    isSelected: currentIndex == index,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.keyName,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String keyName;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isSelected
        ? AppColors.primaryDeep
        : AppColors.textSecondary;

    return Semantics(
      selected: isSelected,
      button: true,
      label: destination.label,
      child: InkWell(
        key: Key(destination.keyName),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                isSelected ? destination.activeIcon : destination.icon,
                size: 22,
                color: color,
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  destination.label,
                  maxLines: 1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: color,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
