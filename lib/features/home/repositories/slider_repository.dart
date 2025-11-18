import '../../../core/repositories/base_repository.dart';
import '../../../core/config/api_config.dart';
import '../models/slide_model.dart';

/// Repository for slider/banner related API calls
class SliderRepository extends BaseRepository {
  SliderRepository({super.apiClient});

  /// Get home slider/banners
  Future<List<SlideModel>> getHomeSlider() async {
    try {
      final response = await apiClient.get(ApiConfig.slides);

      if (response.success && response.data is List) {
        final slides = (response.data as List)
            .map((json) => SlideModel.fromJson(json))
            .where((slide) => slide.enabled)
            .toList();

        // Sort by order
        slides.sort((a, b) => a.order.compareTo(b.order));

        return slides;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
