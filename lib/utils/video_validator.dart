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
          error: 'ملف الفيديو غير موجود',
          errorEn: 'Video file does not exist',
        );
      }

      // Check file size
      final fileSize = await videoFile.length();
      if (fileSize > maxFileSizeBytes) {
        final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
        return VideoValidationResult(
          isValid: false,
          error: 'حجم الفيديو كبير جداً ($fileSizeMB ميجابايت). الحد الأقصى 10 ميجابايت',
          errorEn: 'Video file too large ($fileSizeMB MB). Maximum is 10 MB',
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
            error: 'الفيديو قصير جداً. الحد الأدنى ثانية واحدة',
            errorEn: 'Video too short. Minimum is 1 second',
            videoDuration: duration,
          );
        }

        // Check maximum duration
        if (duration > maxDuration) {
          return VideoValidationResult(
            isValid: false,
            error:
                'الفيديو طويل جداً (${duration.inSeconds} ثانية). الحد الأقصى 60 ثانية',
            errorEn:
                'Video too long (${duration.inSeconds} seconds). Maximum is 60 seconds',
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
          error: 'فشل في قراءة ملف الفيديو. تأكد من صيغة الفيديو',
          errorEn: 'Failed to read video file. Check video format',
        );
      }
    } catch (e) {
      return VideoValidationResult(
        isValid: false,
        error: 'حدث خطأ أثناء التحقق من الفيديو',
        errorEn: 'Error validating video: ${e.toString()}',
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

  /// Get recommended video specifications as a user-friendly string
  static String getVideoRequirements({bool isArabic = true}) {
    if (isArabic) {
      return '''
متطلبات الفيديو:
• المدة: من 1 إلى 60 ثانية
• الحجم: أقل من 10 ميجابايت
• الصيغة: MP4 (موصى به)
• الدقة: 720p أو 1080p
• الاتجاه: عمودي (9:16)
''';
    } else {
      return '''
Video Requirements:
• Duration: 1 to 60 seconds
• Size: Under 10 MB
• Format: MP4 (recommended)
• Resolution: 720p or 1080p
• Orientation: Vertical (9:16)
''';
    }
  }
}

/// Result of video validation
class VideoValidationResult {
  final bool isValid;
  final String? error; // Arabic error message
  final String? errorEn; // English error message
  final Duration? videoDuration;
  final int? fileSizeBytes;

  VideoValidationResult({
    required this.isValid,
    this.error,
    this.errorEn,
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
