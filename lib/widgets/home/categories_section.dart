import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../l10n/app_localizations.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 110,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildCategoryButton(
              context,
              iconPath: 'assets/images/icons/Architect.png',
              label: l10n.architecturalDesign,
              onTap: () => _onCategoryTap(context, 'architecturalDesign'),
            ),
            const SizedBox(width: 12),
            _buildCategoryButton(
              context,
              iconPath: 'assets/images/icons/Love Circled.png',
              label: l10n.socialMedia,
              onTap: () => _onCategoryTap(context, 'socialMedia'),
            ),
            const SizedBox(width: 12),
            _buildCategoryButton(
              context,
              iconPath: 'assets/images/icons/Interior.png',
              label: l10n.interiorDecor,
              onTap: () => _onCategoryTap(context, 'interiorDecor'),
            ),
            const SizedBox(width: 12),
            _buildCategoryButton(
              context,
              iconPath: 'assets/images/icons/Little Black Dress.png',
              label: l10n.fashionDesign,
              onTap: () => _onCategoryTap(context, 'fashionDesign'),
            ),
            const SizedBox(width: 12),
            _buildCategoryButton(
              context,
              iconPath: 'assets/images/icons/Branding.png',
              label: l10n.hobbies,
              onTap: () => _onCategoryTap(context, 'hobbies'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Label
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                height: 1.2,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  void _onCategoryTap(BuildContext context, String category) {
    // Handle category tap
    debugPrint('Category tapped: $category');
    // TODO: Navigate to category page or filter content
  }
}