import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/service_provider.dart';

class ProjectsGallery extends StatefulWidget {
  const ProjectsGallery({super.key});

  @override
  State<ProjectsGallery> createState() => _ProjectsGalleryState();
}

class _ProjectsGalleryState extends State<ProjectsGallery> {
  @override
  void initState() {
    super.initState();
    // Load recommended services/projects when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().loadRecommended();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        // Show loading state
        if (serviceProvider.isLoading && serviceProvider.recommended.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Hide if no projects
        if (serviceProvider.recommended.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.projectsGallery,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onViewAllTap(context),
                    child: Text(
                      l10n.viewAll,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Scrolling Gallery
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: serviceProvider.recommended.length,
                itemBuilder: (context, index) {
                  final service = serviceProvider.recommended[index];
                  return _buildProjectCard(
                    context,
                    serviceId: service.id,
                    serviceName: service.name,
                    imageUrl: service.images.isNotEmpty ? service.images.first : null,
                    price: service.price,
                    rate: service.rate,
                    onTap: () => _onProjectTap(context, service.id, service.name),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String serviceId,
    required String serviceName,
    String? imageUrl,
    required double price,
    required double rate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Project Image - Full size
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 160,
                      width: 160,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          width: 160,
                          color: AppColors.secondary,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 160,
                          width: 160,
                          color: AppColors.secondary,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 160,
                      width: 160,
                      color: AppColors.secondary,
                      child: const Icon(
                        Icons.design_services,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
            ),

            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Service name
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          'SAR ${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Rating
                        if (rate > 0)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rate.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onViewAllTap(BuildContext context) {
    debugPrint('View all projects tapped');
    // TODO: Navigate to projects list page
    // Navigator.pushNamed(context, AppRoutes.projectsList);
  }

  void _onProjectTap(BuildContext context, String serviceId, String serviceName) {
    debugPrint('Project tapped: $serviceName (ID: $serviceId)');
    Navigator.pushNamed(
      context,
      AppRoutes.serviceDetails,
      arguments: {'serviceId': serviceId},
    );
  }
}
