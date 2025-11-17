import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../services/auth_service.dart';

/// Registration screen with both phone and email authentication options
/// Matches the design pattern from login and OTP verification screens
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();

  // Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isPhoneAuth = true; // Toggle between phone and email registration
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validate phone number format
  bool _isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+[0-9]{10,15}$').hasMatch(cleanPhone);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Handle phone registration
  Future<void> _handlePhoneRegister() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();

    // Validation
    if (fullName.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authFullNameRequired;
      });
      return;
    }

    if (phone.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authPhoneRequired;
      });
      return;
    }

    if (!_isValidPhone(phone)) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number with country code (e.g., +966...)';
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authMustAgreeTerms;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Navigate to OTP screen for verification
      // After OTP verification, we'll update the user's display name
      Navigator.pushNamed(
        context,
        AppRoutes.verifyOtp,
        arguments: {
          'phoneNumber': phone,
          'isExistingUser': false,
          'displayName': fullName,
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  /// Handle email/password registration
  Future<void> _handleEmailRegister() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (fullName.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authFullNameRequired;
      });
      return;
    }

    if (email.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authEmailRequired;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authInvalidEmail;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authPasswordRequired;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authPasswordMinLength;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authPasswordsNotMatch;
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authMustAgreeTerms;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authState = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: fullName,
      );

      if (!mounted) return;

      if (authState.isAuthenticated) {
        // Success! Navigate to home
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.authRegisterSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = authState.errorMessage ?? 'Registration failed';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Header with logo (same design as login screen)
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Hawacom',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.authCreateYourAccount,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                // Logo circle
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(width: 5, color: AppColors.primary),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: AppColors.primary,
                      child: const Icon(
                        Icons.person_add_outlined,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Auth method toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPhoneAuth = true;
                          _errorMessage = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isPhoneAuth
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android_rounded,
                              color: _isPhoneAuth
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.authPhoneNumber,
                              style: TextStyle(
                                color: _isPhoneAuth
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPhoneAuth = false;
                          _errorMessage = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isPhoneAuth
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: !_isPhoneAuth
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.authEmail,
                              style: TextStyle(
                                color: !_isPhoneAuth
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Error message
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade900, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorMessage != null) const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              // Registration forms
              _isPhoneAuth ? _buildPhoneForm() : _buildEmailForm(),

            const SizedBox(height: 30),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.authAlreadyHaveAccount,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.authLoginNow,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Build phone registration form
  Widget _buildPhoneForm() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name input
        _buildInputField(
          label: l10n.authFullName,
          controller: _fullNameController,
          hint: l10n.authFullNameHint,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
        ),

        // Phone input
        _buildInputField(
          label: l10n.authPhoneNumber,
          controller: _phoneController,
          hint: l10n.authPhoneHint,
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),

        // Terms & Conditions
        _buildTermsCheckbox(),

        // Register button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            onPressed: _handlePhoneRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: Text(
              l10n.authRegister,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build email/password registration form
  Widget _buildEmailForm() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name input
        _buildInputField(
          label: l10n.authFullName,
          controller: _fullNameController,
          hint: l10n.authFullNameHint,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
        ),

        // Email input
        _buildInputField(
          label: l10n.authEmail,
          controller: _emailController,
          hint: l10n.authEmailHint,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        // Password input
        _buildInputField(
          label: l10n.authPassword,
          controller: _passwordController,
          hint: l10n.authPasswordHint,
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscurePassword,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        // Confirm Password input
        _buildInputField(
          label: l10n.authConfirmPassword,
          controller: _confirmPasswordController,
          hint: l10n.authPasswordHint,
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),

        // Terms & Conditions
        _buildTermsCheckbox(),

        // Register button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            onPressed: _handleEmailRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: Text(
              l10n.authRegister,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build reusable input field
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 14,
        left: 20,
        right: 20,
      ),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && obscureText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(icon, color: AppColors.primary),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Build terms and conditions checkbox
  Widget _buildTermsCheckbox() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
                if (_agreeToTerms) {
                  _errorMessage = null;
                }
              });
            },
            activeColor: AppColors.primary,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _agreeToTerms = !_agreeToTerms;
                  if (_agreeToTerms) {
                    _errorMessage = null;
                  }
                });
              },
              child: Text(
                l10n.authAgreeTerms,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
