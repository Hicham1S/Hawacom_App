import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';

class AIBanner extends StatefulWidget {
  const AIBanner({super.key});

  @override
  State<AIBanner> createState() => _AIBannerState();
}

class _AIBannerState extends State<AIBanner> {
  // Using the same banner image multiple times (simulating multiple banners)
  final List<String> _bannerImages = [
    'assets/images/Banner.png',
    'assets/images/Banner.png',
    'assets/images/Banner.png',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _bannerImages.length;
      });
    });
  }

  void _onBannerTap() {
    // Handle banner tap or button press
    // TODO: Navigate to AI feature or show dialog
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _onBannerTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          minHeight: 150,
          maxHeight: screenHeight * 0.25, // Max 25% of screen height
          maxWidth: double.infinity,
        ),
        height: 180,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bannerWidth = constraints.maxWidth;
            final bannerHeight = constraints.maxHeight;

            return Stack(
              children: [
                // Banner Image with smooth transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                    key: ValueKey<int>(_currentIndex),
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _bannerImages[_currentIndex],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // "اضغط هنا" Button positioned at bottom-right (responsive)
                Positioned(
                  bottom: bannerHeight * 0.11, // 11% from bottom
                  right: bannerWidth * 0.08, // 8% from right
                  child: ElevatedButton(
                    onPressed: _onBannerTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: bannerWidth * 0.06, // 6% of banner width
                        vertical: bannerHeight * 0.10, // 10% of banner height
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
                        fontSize: (screenWidth * 0.035).clamp(
                          12.0,
                          18.0,
                        ), // Min 12px, Max 18px
                      ),
                    ),
                  ),
                ),

                // Page indicators (dots) at bottom-left (responsive)
                Positioned(
                  bottom: bannerHeight * 0.11, // 11% from bottom
                  left: bannerWidth * 0.05, // 5% from left
                  child: Row(
                    children: List.generate(
                      _bannerImages.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: bannerWidth * 0.01, // 1% spacing
                        ),
                        width: (bannerWidth * 0.02).clamp(
                          6.0,
                          12.0,
                        ), // Min 6px, Max 12px
                        height: (bannerWidth * 0.02).clamp(
                          6.0,
                          12.0,
                        ), // Keep circular
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
