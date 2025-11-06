import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/constants/colors.dart';
import 'grid_menu_button.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onMenuTap;

  const TopBar({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Grid Menu Button
          GridMenuButton(onTap: onMenuTap),

          const SizedBox(width: 16),

          // Search Bar (takes remaining space)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Search Icon - Custom SVG
                  SvgPicture.asset(
                    'assets/images/icons/search-normal.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Search text
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.search,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // AI Assistant Icon
                  Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
