import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../models/health_category.dart';
import 'app_surface_card.dart';

/// Tappable speciality card for the dashboard category grid.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final HealthCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      showShadow: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, size: 19, color: category.color),
          ),
          const SizedBox(height: 9),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 11,
              height: 1.25,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
