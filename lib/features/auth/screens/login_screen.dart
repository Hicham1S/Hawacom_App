import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_error_message.dart';

/// Login screen with both phone and email authentication options
/// Refactored with controller pattern and reusable widgets
class LoginScreen extends StatefulWidget {
  final LoginController? controller;

  const LoginScreen({
    super.key,
    this.controller,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _controller;

  // Controllers
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isPhoneAuth = true;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? LoginController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Set error message and stop loading
  void _setError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      if (loading) _errorMessage = null;
    });
  }

  /// Handle phone authentication
  Future<void> _handlePhoneLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final phone = _phoneController.text.trim();

    // Validation
    if (phone.isEmpty) {
      _setError(l10n.authPhoneRequired);
      return;
    }

    if (!_controller.isValidPhone(phone)) {
      _setError(l10n.authInvalidPhoneFormat);
      return;
    }

    _setLoading(true);

    try {
      // Navigate to OTP screen
      Navigator.pushNamed(
        context,
        AppRoutes.verifyOtp,
        arguments: {
          'phoneNumber': phone,
          'isExistingUser': true,
        },
      );

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Handle email/password authentication
  Future<void> _handleEmailLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (email.isEmpty) {
      _setError(l10n.authEmailRequired);
      return;
    }

    if (!_controller.isValidEmail(email)) {
      _setError(l10n.authInvalidEmail);
      return;
    }

    if (password.isEmpty) {
      _setError(l10n.authPasswordRequired);
      return;
    }

    if (password.length < 6) {
      _setError(l10n.authPasswordMinLength);
      return;
    }

    _setLoading(true);

    try {
      final result = await _controller.signInWithEmail(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        // Success! Navigate to home
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.authLoginSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _setError(result.errorMessage ?? 'Login failed');
      }
    } catch (e) {
      _setError('An unexpected error occurred');
    }
  }

  /// Handle forgot password
  Future<void> _handleForgotPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty || !_controller.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authEmailRequired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await _controller.sendPasswordResetEmail(email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? l10n.authResetEmailSent
              : 'Failed to send reset email. Please check your email address.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            // Header with logo
            AuthHeader(
              title: 'Hawacom',
              subtitle: l10n.authWelcomeBack,
            ),

            const SizedBox(height: 30),

            // Auth method toggle
            _buildAuthMethodToggle(l10n),

            const SizedBox(height: 30),

            // Error message
            if (_errorMessage != null) ...[
              AuthErrorMessage(message: _errorMessage!),
              const SizedBox(height: 20),
            ],

            // Loading indicator
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              // Auth forms
              _isPhoneAuth ? _buildPhoneForm(l10n) : _buildEmailForm(l10n),

            const SizedBox(height: 30),

            // Register link
            _buildRegisterLink(l10n),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Build auth method toggle (phone/email)
  Widget _buildAuthMethodToggle(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildToggleButton(
            isSelected: _isPhoneAuth,
            icon: Icons.phone_android_rounded,
            label: l10n.authPhoneNumber,
            onTap: () => setState(() {
              _isPhoneAuth = true;
              _errorMessage = null;
            }),
          ),
          _buildToggleButton(
            isSelected: !_isPhoneAuth,
            icon: Icons.email_outlined,
            label: l10n.authEmail,
            onTap: () => setState(() {
              _isPhoneAuth = false;
              _errorMessage = null;
            }),
          ),
        ],
      ),
    );
  }

  /// Build individual toggle button
  Widget _buildToggleButton({
    required bool isSelected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build phone authentication form
  Widget _buildPhoneForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: l10n.authPhoneNumber,
          hint: l10n.authPhoneHint,
          icon: Icons.phone_android_rounded,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        AuthButton(
          text: l10n.authLogin,
          onPressed: _handlePhoneLogin,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  /// Build email/password authentication form
  Widget _buildEmailForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: l10n.authEmail,
          hint: l10n.authEmailHint,
          icon: Icons.email_outlined,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        AuthTextField(
          label: l10n.authPassword,
          hint: l10n.authPasswordHint,
          icon: Icons.lock_outline,
          controller: _passwordController,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        // Forgot password
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                l10n.authForgotPassword,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        AuthButton(
          text: l10n.authLogin,
          onPressed: _handleEmailLogin,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  /// Build register link
  Widget _buildRegisterLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.authDontHaveAccount,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: Text(
            l10n.authRegisterNow,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
