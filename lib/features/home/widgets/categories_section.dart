import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../providers/category_provider.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  @override
  void initState() {
    super.initState();
    // Load categories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return const SizedBox(
            height: 110,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (categoryProvider.hasError) {
          return SizedBox(
            height: 110,
            child: Center(
              child: Text(
                'Failed to load categories',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (categoryProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoryProvider.categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return _buildCategoryButton(
                  context,
                  categoryId: category.id,
                  imageUrl: category.imageUrl,
                  label: category.name,
                  onTap: () => _onCategoryTap(context, category.id, category.name),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryButton(
    BuildContext context, {
    required String categoryId,
    String? imageUrl,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category icon/image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category,
                            color: AppColors.primary,
                            size: 28,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.category,
                      color: AppColors.primary,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 8),
            // Category name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategoryTap(BuildContext context, String categoryId, String categoryName) {
    debugPrint('Category tapped: $categoryName (ID: $categoryId)');
    // TODO: Navigate to category page with filtered services
    // Navigator.pushNamed(
    //   context,
    //   AppRoutes.categoryDetails,
    //   arguments: {'categoryId': categoryId, 'categoryName': categoryName},
    // );
  }
}
