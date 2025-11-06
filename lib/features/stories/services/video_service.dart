import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/video_validator.dart';

/// Service for handling video-related operations
/// Separates video logic from UI concerns
class VideoService {
  final ImagePicker _picker = ImagePicker();

  /// Pick a video from gallery and validate it
  Future<VideoPickResult> pickVideoFromGallery() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: VideoValidator.maxDuration,
      );

      if (video == null) {
        return VideoPickResult.cancelled();
      }

      final videoFile = File(video.path);
      final validation = await VideoValidator.validateVideo(videoFile);

      return VideoPickResult(
        file: videoFile,
        validation: validation,
        isCancelled: false,
      );
    } catch (e) {
      return VideoPickResult.error('videoPickFailed');
    }
  }

  /// Record a video with camera and validate it
  Future<VideoPickResult> recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: VideoValidator.maxDuration,
      );

      if (video == null) {
        return VideoPickResult.cancelled();
      }

      final videoFile = File(video.path);
      final validation = await VideoValidator.validateVideo(videoFile);

      return VideoPickResult(
        file: videoFile,
        validation: validation,
        isCancelled: false,
      );
    } catch (e) {
      return VideoPickResult.error('videoRecordFailed');
    }
  }

  /// Pick an image from gallery
  Future<ImagePickResult> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return ImagePickResult.cancelled();
      }

      return ImagePickResult(
        file: File(image.path),
        isCancelled: false,
      );
    } catch (e) {
      return ImagePickResult.error('imagePickFailed');
    }
  }

  /// Upload a video file (placeholder for future implementation)
  Future<String?> uploadVideo(File videoFile) async {
    // TODO: Implement video upload to cloud storage
    // Return the URL of the uploaded video
    return null;
  }

  /// Upload an image file (placeholder for future implementation)
  Future<String?> uploadImage(File imageFile) async {
    // TODO: Implement image upload to cloud storage
    // Return the URL of the uploaded image
    return null;
  }
}

/// Result of a video pick operation
class VideoPickResult {
  final File? file;
  final VideoValidationResult? validation;
  final bool isCancelled;
  final String? errorKey;

  VideoPickResult({
    this.file,
    this.validation,
    required this.isCancelled,
    this.errorKey,
  });

  factory VideoPickResult.cancelled() {
    return VideoPickResult(isCancelled: true);
  }

  factory VideoPickResult.error(String errorKey) {
    return VideoPickResult(
      isCancelled: false,
      errorKey: errorKey,
    );
  }

  bool get isValid => validation?.isValid ?? false;
  bool get hasError => errorKey != null || (validation?.isValid == false);
}

/// Result of an image pick operation
class ImagePickResult {
  final File? file;
  final bool isCancelled;
  final String? errorKey;

  ImagePickResult({
    this.file,
    required this.isCancelled,
    this.errorKey,
  });

  factory ImagePickResult.cancelled() {
    return ImagePickResult(isCancelled: true);
  }

  factory ImagePickResult.error(String errorKey) {
    return ImagePickResult(
      isCancelled: false,
      errorKey: errorKey,
    );
  }

  bool get hasFile => file != null;
  bool get hasError => errorKey != null;
}
