import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/colors.dart';

/// Screen displayed when the add button is tapped
class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSearchTap() {
    // TODO: Implement search functionality with API
    debugPrint('Search tapped: ${_searchController.text}');
  }

  void _onDropdownTap() {
    // TODO: Implement dropdown functionality with API
    debugPrint('Dropdown tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar with dropdown and search icons
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Search icon (on the right in RTL)
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 8),
                        child: GestureDetector(
                          onTap: _onSearchTap,
                          child: SvgPicture.asset(
                            'assets/images/icons/search-normal.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      // Search text field
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'البحث عن الفئة',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      // Dropdown icon (on the left in RTL)
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        onPressed: _onDropdownTap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description section title
                const Text(
                  'وصف فكرة المشروع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Description box with highlighter icon
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Text field
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 50),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 6,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'اكتب وصفا مختصرا عن المشروع، النمط المطلوب، والافكار الاساسية',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // Highlighter icon at top right
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Image.asset(
                          'assets/images/icons/highlighter.png',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
