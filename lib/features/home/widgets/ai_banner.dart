import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/slider_provider.dart';

class AIBanner extends StatefulWidget {
  const AIBanner({super.key});

  @override
  State<AIBanner> createState() => _AIBannerState();
}

class _AIBannerState extends State<AIBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Load slider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SliderProvider>();
      provider.loadSlider().then((_) {
        // Start auto-rotation if slides loaded successfully
        if (provider.hasSlides) {
          _startAutoRotation();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final provider = context.read<SliderProvider>();
      if (provider.hasSlides) {
        final nextIndex = (provider.currentIndex + 1) % provider.slides.length;
        provider.setCurrentIndex(nextIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<SliderProvider>(
      builder: (context, sliderProvider, child) {
        // Show loading state
        if (sliderProvider.isLoading) {
          return Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Show fallback banner if no slides from API
        if (!sliderProvider.hasSlides) {
          return _buildFallbackBanner(screenWidth, screenHeight);
        }

        final currentSlide = sliderProvider.slides[sliderProvider.currentIndex];

        return GestureDetector(
          onTap: () => _onBannerTap(currentSlide.id),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 180,
            child: Stack(
              children: [
                // Banner Image
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                    key: ValueKey<int>(sliderProvider.currentIndex),
                    borderRadius: BorderRadius.circular(16),
                    child: currentSlide.imageUrl != null && currentSlide.imageUrl!.isNotEmpty
                        ? Image.network(
                            currentSlide.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackImage();
                            },
                          )
                        : _buildFallbackImage(),
                  ),
                ),

                // Button if provided
                if (currentSlide.button != null && currentSlide.button!.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    right: screenWidth * 0.08,
                    child: ElevatedButton(
                      onPressed: () => _onBannerTap(currentSlide.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        currentSlide.button!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                        ),
                      ),
                    ),
                  ),

                // Page indicators if multiple slides
                if (sliderProvider.slides.length > 1)
                  Positioned(
                    bottom: 20,
                    left: screenWidth * 0.05,
                    child: Row(
                      children: List.generate(
                        sliderProvider.slides.length,
                        (index) => GestureDetector(
                          onTap: () => sliderProvider.setCurrentIndex(index),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            width: (screenWidth * 0.02).clamp(6.0, 12.0),
                            height: (screenWidth * 0.02).clamp(6.0, 12.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == sliderProvider.currentIndex
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Fallback banner with hardcoded assets
  Widget _buildFallbackBanner(double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: _onDefaultBannerTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 180,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/Banner.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 20,
              right: screenWidth * 0.08,
              child: ElevatedButton(
                onPressed: _onDefaultBannerTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  AppLocalizations.of(context)!.clickHere,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/images/Banner.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.secondary,
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  void _onBannerTap(String slideId) {
    debugPrint('Banner tapped: $slideId');
    // TODO: Navigate based on slide configuration
  }

  void _onDefaultBannerTap() {
    debugPrint('Default banner tapped');
    // TODO: Navigate to AI feature or show dialog
  }
}
