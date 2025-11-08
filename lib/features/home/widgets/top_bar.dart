import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/constants/colors.dart';
import 'grid_menu_button.dart';

class TopBar extends StatefulWidget {
  final VoidCallback onMenuTap;
  final Function(String)? onSearch; // Optional search callback

  const TopBar({
    super.key,
    required this.onMenuTap,
    this.onSearch,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    // Call the search callback if provided
    widget.onSearch?.call(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Grid Menu Button
          GridMenuButton(onTap: widget.onMenuTap),

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

                  // Search TextField
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right, // Align to right, let Flutter auto-detect direction
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: _handleSearchChanged,
                    ),
                  ),

                  // Clear button (shows when typing)
                  if (_isSearching)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    )
                  else
                    // AI Assistant Icon (shows when not typing)
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
