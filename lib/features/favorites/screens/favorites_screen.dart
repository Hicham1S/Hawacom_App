import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../services/providers/service_provider.dart';
import '../providers/favorite_provider.dart';

/// Screen showing user's favorite services
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<FavoriteProvider>().loadFavorites();
      // Sync favorite IDs to ServiceProvider to fix API's incorrect is_favorite
      _syncFavorites();
    });
  }

  void _syncFavorites() {
    final favoriteProvider = context.read<FavoriteProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    final favoriteIds = favoriteProvider.favorites.map((f) => f.service.id).toSet();
    serviceProvider.syncFavoriteIds(favoriteIds);
  }

  Future<void> _onRefresh() async {
    await context.read<FavoriteProvider>().refresh();
    _syncFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'المفضلة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<FavoriteProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.favorites.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (provider.hasError && provider.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'خطأ في تحميل المفضلة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? '',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadFavorites(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (provider.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد خدمات مفضلة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ابدأ بإضافة خدماتك المفضلة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.explore),
                      label: const Text('استكشف الخدمات'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.favorites.length,
                itemBuilder: (context, index) {
                  final favorite = provider.favorites[index];
                  final service = favorite.service;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.serviceDetails,
                            arguments: {'serviceId': service.id},
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: service.media.isNotEmpty
                                    ? Image.network(
                                        service.media.first.url,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 80,
                                          height: 80,
                                          color: AppColors.textSecondary.withValues(alpha: 0.1),
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                                        child: Icon(
                                          Icons.cleaning_services,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),

                              // Service Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Service Name
                                    Text(
                                      service.name,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),

                                    // Provider Name
                                    if (service.providerName != null)
                                      Text(
                                        service.providerName!,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 4),

                                    // Rating
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          service.rate.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Price
                                    Text(
                                      '${service.actualPrice.toStringAsFixed(2)} ر.س',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Remove from Favorites Button
                              IconButton(
                                onPressed: () async {
                                  // Show confirmation dialog
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('إزالة من المفضلة'),
                                      content: const Text('هل تريد إزالة هذه الخدمة من المفضلة؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            'إزالة',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final success = await provider.removeFromFavorites(service.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'تمت الإزالة من المفضلة'
                                                : 'فشلت الإزالة من المفضلة',
                                          ),
                                          backgroundColor: success
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
