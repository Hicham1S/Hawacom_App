import 'dart:io';
import 'package:video_player/video_player.dart';

/// Utility class for validating video files before upload
class VideoValidator {
  /// Maximum allowed video duration for stories (60 seconds)
  static const Duration maxDuration = Duration(seconds: 60);

  /// Minimum allowed video duration for stories (1 second)
  static const Duration minDuration = Duration(seconds: 1);

  /// Maximum allowed file size (10 MB)
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB

  /// Result of video validation
  static Future<VideoValidationResult> validateVideo(File videoFile) async {
    try {
      // Check if file exists
      if (!await videoFile.exists()) {
        return VideoValidationResult(
          isValid: false,
          errorKey: 'videoFileNotExist',
        );
      }

      // Check file size
      final fileSize = await videoFile.length();
      if (fileSize > maxFileSizeBytes) {
        final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
        return VideoValidationResult(
          isValid: false,
          errorKey: 'videoFileTooLarge',
          errorParams: {'size': fileSizeMB},
        );
      }

      // Initialize video player to get duration
      final controller = VideoPlayerController.file(videoFile);

      try {
        await controller.initialize();
        final duration = controller.value.duration;

        // Dispose controller after getting duration
        await controller.dispose();

        // Check minimum duration
        if (duration < minDuration) {
          return VideoValidationResult(
            isValid: false,
            errorKey: 'videoTooShort',
            videoDuration: duration,
          );
        }

        // Check maximum duration
        if (duration > maxDuration) {
          return VideoValidationResult(
            isValid: false,
            errorKey: 'videoTooLong',
            errorParams: {'duration': duration.inSeconds},
            videoDuration: duration,
          );
        }

        // Video is valid
        return VideoValidationResult(
          isValid: true,
          videoDuration: duration,
          fileSizeBytes: fileSize,
        );
      } catch (e) {
        // Error initializing video
        await controller.dispose();
        return VideoValidationResult(
          isValid: false,
          errorKey: 'videoReadError',
        );
      }
    } catch (e) {
      return VideoValidationResult(
        isValid: false,
        errorKey: 'videoValidationError',
      );
    }
  }

  /// Check if a video duration is within acceptable range
  static bool isDurationValid(Duration duration) {
    return duration >= minDuration && duration <= maxDuration;
  }

  /// Format duration for display (e.g., "1:30" for 1 minute 30 seconds)
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get video requirement localization keys
  /// Use these keys with AppLocalizations to display localized requirements
  static List<String> getVideoRequirementKeys() {
    return [
      'videoRequirementsTitle',
      'videoRequirementDuration',
      'videoRequirementSize',
      'videoRequirementFormat',
      'videoRequirementResolution',
      'videoRequirementOrientation',
    ];
  }
}

/// Result of video validation
class VideoValidationResult {
  final bool isValid;
  final String? errorKey; // Localization key for error message
  final Map<String, dynamic>? errorParams; // Parameters for localized message
  final Duration? videoDuration;
  final int? fileSizeBytes;

  VideoValidationResult({
    required this.isValid,
    this.errorKey,
    this.errorParams,
    this.videoDuration,
    this.fileSizeBytes,
  });

  /// Get file size in MB
  double? get fileSizeMB =>
      fileSizeBytes != null ? fileSizeBytes! / (1024 * 1024) : null;

  /// Get formatted duration string
  String? get formattedDuration =>
      videoDuration != null ? VideoValidator.formatDuration(videoDuration!) : null;
}
