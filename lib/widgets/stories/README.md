# Story Widgets

This directory contains widgets specifically designed for the story viewing feature.

## StoryVideoPlayer

A specialized video player widget for story segments that integrates seamlessly with the story viewer's progress tracking system.

### Features

- **Automatic Playback**: Videos start playing automatically when the segment loads
- **Progress Synchronization**: Video progress is synced with the story progress bar
- **Error Handling**: Gracefully handles video loading errors and automatically skips to the next segment
- **Network & Asset Support**: Supports both network URLs and local asset videos
- **Lifecycle Management**: Properly disposes resources and cleans up listeners

### Usage

```dart
StoryVideoPlayer(
  videoUrl: 'https://example.com/video.mp4', // or 'assets/videos/story.mp4'
  progressController: _progressController,
  onVideoCompleted: () {
    // Called when video finishes playing
    _nextSegment();
  },
  onVideoError: () {
    // Called if video fails to load or encounters an error
    _showError();
  },
)
```

### Integration with StoryViewScreen

The `StoryVideoPlayer` is already integrated into `StoryViewScreen` and will automatically be used when a story segment has `mediaType: StoryMediaType.video`.

### Video URLs

For testing, the mock data includes sample videos from Google's test video repository:
- Big Buck Bunny - Short animation clip
- Elephants Dream - Another test video

For production, replace these with your actual video URLs from:
- Cloud storage (AWS S3, Google Cloud Storage, Azure Blob)
- CDN services (Cloudflare, CloudFront)
- Local assets (place videos in `assets/videos/` and declare in pubspec.yaml)

### Performance Considerations

1. **Video Size**: Keep video files under 5-10MB for mobile performance
2. **Format**: Use MP4 with H.264 codec for best compatibility
3. **Resolution**: 720p (1280x720) is recommended for stories
4. **Duration**:
   - **Recommended**: 15-30 seconds for optimal engagement
   - **Maximum**: 60 seconds (enforced - videos automatically stop and advance after 60s)
   - **Minimum**: 3-5 seconds

### Platform-Specific Setup

The video_player package requires platform-specific configuration:

#### Android
No additional setup required for basic functionality.

For internet videos, ensure you have internet permission in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### iOS
No additional setup required for basic functionality.

#### Web
Videos from external domains require CORS to be properly configured on the video hosting server.

### Troubleshooting

**Video doesn't play:**
- Check that the URL is accessible
- Verify the video format is supported (MP4/H.264 recommended)
- Check internet connectivity for network videos
- Ensure assets are properly declared in pubspec.yaml for local videos

**Progress bar doesn't match video:**
- The progress controller duration is automatically set to match the video duration once initialized
- If you see issues, check that the `progressController` passed to the widget has proper lifecycle management

**Memory issues:**
- Videos are automatically disposed when the widget is disposed
- The video player stops and releases resources when navigating away
- Consider implementing video preloading for smoother transitions (advanced feature)
