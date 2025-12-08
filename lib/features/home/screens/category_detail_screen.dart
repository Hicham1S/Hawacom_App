import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../services/models/service_model.dart';
import '../../services/repositories/service_repository.dart';

/// Category detail screen showing services in a category
class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  List<ServiceModel> _services = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final services = await _serviceRepository.getServicesByCategory(
        widget.categoryId,
        limit: 50,
      );
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل تحميل الخدمات: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_services.isEmpty) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildServiceCard(service),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              // Service image
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
                          color: AppColors.background,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (service.description != null)
                      Text(
                        service.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          service.rate.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${service.actualPrice.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadServices,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.categoryDetailRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد خدمات في هذه الفئة',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'جرب فئة أخرى أو تحقق لاحقاً',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
