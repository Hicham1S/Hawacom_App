import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../utils/video_validator.dart';

/// Screen for adding a new story (image or video)
/// This is an example implementation showing how to validate videos before upload
class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  File? _selectedFile;
  bool _isVideo = false;
  bool _isValidating = false;
  VideoValidationResult? _validationResult;

  final ImagePicker _picker = ImagePicker();

  /// Get localized error message from validation result
  String _getLocalizedError(BuildContext context, VideoValidationResult result) {
    final l10n = AppLocalizations.of(context)!;
    final errorKey = result.errorKey;

    if (errorKey == null) return 'Unknown error';

    switch (errorKey) {
      case 'videoFileNotExist':
        return l10n.videoFileNotExist;
      case 'videoFileTooLarge':
        final size = result.errorParams?['size'] ?? '?';
        return l10n.videoFileTooLarge(size);
      case 'videoTooShort':
        return l10n.videoTooShort;
      case 'videoTooLong':
        final duration = result.errorParams?['duration'] ?? 0;
        return l10n.videoTooLong(duration);
      case 'videoReadError':
        return l10n.videoReadError;
      case 'videoValidationError':
        return l10n.videoValidationError;
      default:
        return errorKey;
    }
  }

  /// Pick video from gallery
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: VideoValidator.maxDuration, // Limit picker to 60 seconds
      );

      if (video == null) return;

      // Show loading indicator
      setState(() {
        _isValidating = true;
        _validationResult = null;
      });

      final videoFile = File(video.path);

      // Validate video
      final result = await VideoValidator.validateVideo(videoFile);

      setState(() {
        _isValidating = false;
        _validationResult = result;

        if (result.isValid) {
          _selectedFile = videoFile;
          _isVideo = true;
        } else {
          _selectedFile = null;
          // Show error message
          _showErrorDialog(_getLocalizedError(context, result));
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });

      final l10n = AppLocalizations.of(context)!;
      _showErrorDialog(l10n.videoPickFailed);
    }
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress image
      );

      if (image == null) return;

      setState(() {
        _selectedFile = File(image.path);
        _isVideo = false;
        _validationResult = null;
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showErrorDialog(l10n.imagePickFailed);
    }
  }

  /// Record video with camera
  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: VideoValidator.maxDuration, // Limit recording to 60 seconds
      );

      if (video == null) return;

      // Show loading indicator
      setState(() {
        _isValidating = true;
        _validationResult = null;
      });

      final videoFile = File(video.path);

      // Validate video
      final result = await VideoValidator.validateVideo(videoFile);

      setState(() {
        _isValidating = false;
        _validationResult = result;

        if (result.isValid) {
          _selectedFile = videoFile;
          _isVideo = true;
        } else {
          _selectedFile = null;
          _showErrorDialog(_getLocalizedError(context, result));
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });

      final l10n = AppLocalizations.of(context)!;
      _showErrorDialog(l10n.videoRecordFailed);
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(l10n.error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      ),
    );
  }

  /// Upload story (placeholder - implement with your backend)
  Future<void> _uploadStory() async {
    if (_selectedFile == null) return;

    // TODO: Implement actual upload to your backend
    // Example:
    // 1. Upload file to cloud storage (S3, Firebase, etc.)
    // 2. Create story record in database
    // 3. Return to previous screen

    // For now, just show success message
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.storyUploadingSoon),
          duration: const Duration(seconds: 2),
        ),
      );

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            l10n.addStoryTitle,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (_selectedFile != null)
              TextButton(
                onPressed: _uploadStory,
                child: Text(
                  l10n.publish,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // Preview area
            Expanded(
              child: _buildPreview(),
            ),

            // Media selection buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video requirements info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.videoRequirementsSummary,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildMediaButton(
                          icon: Icons.videocam,
                          label: l10n.recordVideo,
                          onTap: _recordVideo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMediaButton(
                          icon: Icons.video_library,
                          label: l10n.selectVideo,
                          onTap: _pickVideo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMediaButton(
                          icon: Icons.photo_library,
                          label: l10n.selectImage,
                          onTap: _pickImage,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Validation result
                  if (_validationResult != null && _validationResult!.isValid)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.videoSuitable(_validationResult!.formattedDuration ?? ''),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    if (_isValidating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              l10n.videoValidating,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_selectedFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectImageOrVideo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Show preview
    if (_isVideo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.videoSelected,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            if (_validationResult?.formattedDuration != null)
              Text(
                _validationResult!.formattedDuration!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      );
    } else {
      return Image.file(
        _selectedFile!,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
