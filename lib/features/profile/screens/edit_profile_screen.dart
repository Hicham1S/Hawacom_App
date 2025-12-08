import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/session_manager.dart';
import '../../../core/localization/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../repositories/profile_repository.dart';

/// Edit profile screen with all editable fields
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _selectedImage;
  String? _uploadedAvatarUrl;
  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  bool _hidePassword = true;
  bool _changePassword = false;

  late final ProfileRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = ProfileRepository(); // Uses default singletons
    // Delay loading until after build to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndLoadUser();
    });
  }

  Future<void> _initializeAndLoadUser() async {
    final authProvider = context.read<AuthProvider>();

    debugPrint('=== EDIT PROFILE INIT ===');
    debugPrint('AuthProvider initialized: ${authProvider.isInitialized}');
    debugPrint('Current user: ${authProvider.currentUser?.name}');
    debugPrint('Is authenticated: ${authProvider.isAuthenticated}');

    // Check SessionManager data
    final sessionManager = SessionManager();
    await sessionManager.initialize();
    final isLoggedIn = await sessionManager.isLoggedIn();
    final token = await sessionManager.getToken();
    final userData = await sessionManager.getUser();

    debugPrint('=== SESSION DATA ===');
    debugPrint('Is logged in (SessionManager): $isLoggedIn');
    debugPrint('Token exists: ${token != null}');
    if (token != null) {
      debugPrint('Token (first 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
    }
    debugPrint('User data exists: ${userData != null}');
    if (userData != null) {
      debugPrint('User data keys: ${userData.keys.toList()}');
    }

    // Ensure AuthProvider is initialized
    if (!authProvider.isInitialized) {
      debugPrint('Initializing AuthProvider...');
      await authProvider.initialize();
      debugPrint('After init - Current user: ${authProvider.currentUser?.name}');
    }

    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Upload immediately to Firebase Storage
      if (mounted) {
        await _uploadAvatar();
      }
    }
  }

  Future<void> _uploadAvatar() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final avatarUrl = await _repository.uploadAvatar(
        imageFile: _selectedImage!,
        userId: user.id,
      );

      setState(() {
        _uploadedAvatarUrl = avatarUrl;
        _isUploadingAvatar = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.editProfileUploadSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUploadingAvatar = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.editProfileUploadFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
        );
      }
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.editProfilePhotoGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.editProfileCamera),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser == null) {
        // User not authenticated - redirect to login
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.editProfileSessionExpired),
            backgroundColor: Colors.orange,
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
        return;
      }

      debugPrint('=== PROFILE UPDATE DEBUG ===');
      debugPrint('User ID: ${currentUser.id}');
      debugPrint('Name: ${_nameController.text.trim()}');
      debugPrint('Email: ${_emailController.text.trim()}');
      debugPrint('Phone: ${_phoneController.text.trim()}');
      debugPrint('Avatar URL: $_uploadedAvatarUrl');
      debugPrint('Change Password: $_changePassword');
      debugPrint('API Token available: ${currentUser.apiToken != null}');
      if (currentUser.apiToken != null) {
        debugPrint('API Token (first 20 chars): ${currentUser.apiToken!.substring(0, currentUser.apiToken!.length > 20 ? 20 : currentUser.apiToken!.length)}...');
      }

      // Update profile (with optional password change)
      final updatedUser = await _repository.updateProfile(
        userId: currentUser.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: _uploadedAvatarUrl,
        password: _changePassword && _newPasswordController.text.isNotEmpty
            ? _newPasswordController.text
            : null,
      );

      debugPrint('Profile update successful!');
      debugPrint('Updated user: ${updatedUser.toJson()}');

      // Update auth provider
      await authProvider.updateUser(updatedUser);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.editProfileSaveSuccess),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e, stackTrace) {
      debugPrint('=== PROFILE UPDATE ERROR ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.editProfileSaveFailed(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _loadUserData();
    setState(() {
      _selectedImage = null;
      _uploadedAvatarUrl = null;
      _changePassword = false;
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text(
            'تعديل الملف الشخصي',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (user?.photoUrl != null
                              ? NetworkImage(user!.photoUrl!)
                              : null) as ImageProvider?,
                      child: _selectedImage == null &&
                              user?.photoUrl == null
                          ? Text(
                              user?.name.isNotEmpty == true
                                  ? user!.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 48,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    if (_isUploadingAvatar)
                      Positioned.fill(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black54,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _showImagePicker,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Profile Details
              Text(
                'معلومات الملف الشخصي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  if (value.trim().length < 3) {
                    return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الجوال',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رقم الجوال';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Change Password Section
              Row(
                children: [
                  Checkbox(
                    value: _changePassword,
                    onChanged: (value) {
                      setState(() {
                        _changePassword = value ?? false;
                        if (!_changePassword) {
                          _oldPasswordController.clear();
                          _newPasswordController.clear();
                          _confirmPasswordController.clear();
                        }
                      });
                    },
                  ),
                  Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              if (_changePassword) ...[
                const SizedBox(height: 16),

                // Old Password
                TextFormField(
                  controller: _oldPasswordController,
                  textDirection: TextDirection.ltr,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور القديمة',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return 'الرجاء إدخال كلمة المرور القديمة';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // New Password
                TextFormField(
                  controller: _newPasswordController,
                  textDirection: TextDirection.ltr,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الجديدة';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  textDirection: TextDirection.ltr,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (_changePassword) {
                      if (value != _newPasswordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, -2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'حفظ التعديلات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _isLoading ? null : _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إعادة تعيين',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
