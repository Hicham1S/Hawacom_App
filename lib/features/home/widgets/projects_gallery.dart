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
              height: 220,
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
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
                          height: 120,
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
                      height: 120,
                      color: AppColors.secondary,
                      child: const Icon(
                        Icons.design_services,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
            ),

            // Project Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Service name
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          'SAR ${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        // Rating
                        if (rate > 0)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rate.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
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
