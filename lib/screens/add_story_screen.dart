import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
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
          _showErrorDialog(result.error ?? result.errorEn ?? 'Invalid video');
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });

      _showErrorDialog('فشل في اختيار الفيديو');
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
      _showErrorDialog('فشل في اختيار الصورة');
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
          _showErrorDialog(result.error ?? result.errorEn ?? 'Invalid video');
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });

      _showErrorDialog('فشل في تسجيل الفيديو');
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('سيتم إضافة ستوري قريباً'),
          duration: Duration(seconds: 2),
        ),
      );

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text(
            'إضافة ستوري',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (_selectedFile != null)
              TextButton(
                onPressed: _uploadStory,
                child: const Text(
                  'نشر',
                  style: TextStyle(
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
                            'الفيديو: من 1 إلى 60 ثانية، أقل من 10 ميجابايت',
                            style: TextStyle(
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
                          label: 'تسجيل فيديو',
                          onTap: _recordVideo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMediaButton(
                          icon: Icons.video_library,
                          label: 'اختيار فيديو',
                          onTap: _pickVideo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMediaButton(
                          icon: Icons.photo_library,
                          label: 'اختيار صورة',
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
                              'الفيديو مناسب (${_validationResult!.formattedDuration})',
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
    if (_isValidating) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'جاري التحقق من الفيديو...',
              style: TextStyle(color: AppColors.textSecondary),
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
              'اختر صورة أو فيديو',
              style: TextStyle(
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
            Icon(
              Icons.video_library,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'فيديو محدد',
              style: TextStyle(
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
