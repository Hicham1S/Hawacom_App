import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ✅ Import for SVG icons
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // First button - Start Design Project
          _buildActionButton(
            context,
            text: l10n.startDesignProject,
            iconPath: 'assets/images/icons/pen-tool.svg',
            color: AppColors.primary,
            onTap: () => _onActionTap(context, 'design_project'),
          ),

          const SizedBox(width: 12),

          // Second button - Create AI Images
          _buildActionButton(
            context,
            text: l10n.createAIImages,
            iconPath: 'assets/images/icons/magicpen.svg',
            color: AppColors.accent,
            onTap: () => _onActionTap(context, 'ai_images'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SVG icon on the right (in RTL)
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 12),

            // Text on the left (in RTL) - fully visible, no ellipsis
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onActionTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: $action'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
