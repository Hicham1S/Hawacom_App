import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  // Available images
  static const List<String> _availableImages = [
    'assets/images/Ahmad.png',
    'assets/images/Amina.png',
    'assets/images/Me.png',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildStoryCard(context, l10n.addStory, null, isAdd: true),
          _buildStoryCard(
            context,
            l10n.ahmadAlShehri,
            _availableImages[0],
            isLive: true,
          ),
          _buildStoryCard(
            context,
            l10n.aminaAlHajri,
            _availableImages[1],
            isLive: false,
          ),
          _buildStoryCard(
            context,
            l10n.mohammedAli,
            _availableImages[2],
            isLive: false,
          ),
          _buildStoryCard(
            context,
            l10n.sarahAhmed,
            _availableImages[1],
            isLive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(
    BuildContext context,
    String name,
    String? imagePath, {
    bool isAdd = false,
    bool isLive = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          // Rectangle card without gradient border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  // Background image (including for Add Story)
                  if (isAdd)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/Me.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  else if (imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                  // Circular + icon for Add Story (centered)
                  if (isAdd)
                    Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                  // Gradient overlay for better text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // User name with circular profile picture at bottom
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      children: [
                        // Circular profile picture with red border
                        if (!isAdd)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.liveIndicator,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                imagePath ?? 'assets/images/Me.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        if (!isAdd) const SizedBox(width: 6),

                        // User name
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 8),
                              ],
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Live badge
          if (isLive)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.liveIndicator,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.live,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
