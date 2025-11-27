import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../services/models/media_model.dart';

/// Gallery screen for viewing images with carousel, zoom, and pan
class GalleryScreen extends StatefulWidget {
  final List<MediaModel> mediaList;
  final int initialIndex;
  final String? heroTag;

  const GalleryScreen({
    super.key,
    required this.mediaList,
    this.initialIndex = 0,
    this.heroTag,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late int _currentIndex;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white70),
        ),
        body: const Center(
          child: Text(
            'لا توجد صور',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    final currentMedia = widget.mediaList[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text(
          'معرض الصور',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // Image counter
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentIndex + 1} / ${widget.mediaList.length}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            // Image Carousel with Zoom/Pan
            Hero(
              tag: widget.heroTag != null
                  ? '${widget.heroTag}_${currentMedia.id}'
                  : 'gallery_${currentMedia.id}',
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  viewportFraction: 1.0,
                  height: double.infinity,
                  initialPage: widget.initialIndex,
                  enableInfiniteScroll: widget.mediaList.length > 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.mediaList.map((media) {
                  return InteractiveViewer(
                    scaleEnabled: true,
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Container(
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          media.url,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white70,
                                    size: 60,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'فشل تحميل الصورة',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Image Name/Description at Bottom
            if (currentMedia.name != null && currentMedia.name!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  currentMedia.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: const [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 6.0,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),

            // Navigation Dots (if more than one image)
            if (widget.mediaList.length > 1)
              Positioned(
                bottom: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.mediaList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
