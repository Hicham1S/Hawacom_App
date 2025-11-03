import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../data/mock_data.dart';
import '../../models/story.dart';
import '../../screens/story_view_screen.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  void _openStoryViewer(BuildContext context, int index) {
    final stories = MockData.getStories();
    final story = stories[index];

    // Check if this is the "Add Story" button
    if (story.isAddStory) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.addStoryComingSoon),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if story has no segments
    if (story.segments.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.storyHasNoContent),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Filter out "Add Story" button and stories without segments for the viewer
    final viewableStories = stories
        .where((s) => !s.isAddStory && s.segments.isNotEmpty)
        .toList();

    // Find the actual index in the filtered list
    final viewableIndex = viewableStories.indexOf(story);

    if (viewableIndex == -1) {
      // This shouldn't happen, but handle it gracefully
      return;
    }

    // Navigate to story viewer
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          stories: viewableStories,
          initialStoryIndex: viewableIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allStories = MockData.getStories();

    // Filter: Keep "Add Story" button OR stories with segments
    // This hides broken/empty stories from the UI
    final displayStories = allStories.where((story) {
      return story.isAddStory || story.segments.isNotEmpty;
    }).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: displayStories.length,
        itemBuilder: (context, index) {
          final story = displayStories[index];
          return GestureDetector(
            onTap: () => _openStoryViewer(context, allStories.indexOf(story)),
            child: _buildStoryCard(
              context,
              story,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, Story story) {
    final l10n = AppLocalizations.of(context)!;
    final isAdd = story.isAddStory;
    final isLive = story.isLive;
    final isViewed = story.isViewed;

    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          // Rectangle card with gradient border for unviewed stories
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // Add gradient border for unviewed stories
              gradient: !isAdd && !isViewed
                  ? const LinearGradient(
                      colors: AppColors.instagramStoryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isViewed ? Colors.grey.shade300 : Colors.transparent,
            ),
            child: Container(
              margin: const EdgeInsets.all(2), // Space for gradient border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  // Background image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: story.userImage.startsWith('http')
                        ? Image.network(
                            story.userImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/Me.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
                          )
                        : Image.asset(
                            story.userImage,
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
                        // Circular profile picture with border
                        if (!isAdd)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isViewed
                                    ? Colors.grey
                                    : AppColors.liveIndicator,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: story.userImage.startsWith('http')
                                  ? Image.network(
                                      story.userImage,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      story.userImage,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                        if (!isAdd) const SizedBox(width: 6),

                        // User name
                        Expanded(
                          child: Text(
                            story.userName,
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
