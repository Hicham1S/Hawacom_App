import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/session_manager.dart';
import '../models/user_model.dart';

/// OTP Verification screen - Verify phone number with OTP code
/// Following the design pattern from old project
/// Handles both login and registration flows
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? verificationId;
  final bool isExistingUser;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.verificationId,
    this.isExistingUser = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-send OTP notification when screen loads
    _sendOtp();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  /// Send OTP to phone number
  /// TEMPORARY: Simulating OTP send (static OTP: 123456)
  /// TODO: Replace with 3rd party SMS service integration
  Future<void> _sendOtp() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    // Simulate sending OTP
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isResending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent: 123456 (Static for testing)'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Verify OTP code
  /// TEMPORARY: Using static OTP (123456) until 3rd party SMS service is integrated
  /// TODO: Replace with 3rd party SMS service integration
  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.authInvalidOTP;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate verification delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // TEMPORARY: Static OTP verification
    const String staticOtp = '123456';

    if (_otpController.text.trim() == staticOtp) {
      // OTP is correct, save session and navigate to home
      // TEMPORARY: Create a temporary user for static OTP login
      final tempUser = UserModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        email: widget.phoneNumber, // Using phone as email for now
        phoneNumber: widget.phoneNumber,
        displayName: 'User',
        emailVerified: true,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Save session
      final sessionManager = SessionManager();
      await sessionManager.saveUser(tempUser);

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authLoginSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Invalid OTP
      setState(() {
        _isLoading = false;
        _errorMessage = AppLocalizations.of(context)!.authInvalidOTP;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      appBar: AppBar(
        title: Text(
          widget.isExistingUser ? l10n.authVerifyOTP : 'Register',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Header with logo (same design as login)
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.isExistingUser
                            ? 'Welcome back!'
                            : 'Welcome to the best service provider system!',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
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
                    child: Icon(
                      Icons.people_alt_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    widget.isExistingUser
                        ? '${l10n.authEnterOTP}\n${widget.phoneNumber}'
                        : 'Enter the verification code sent to\n${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // ✅ Dark text
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

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
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 20),

                // OTP Input Field - Following OLD TextFieldWidget design
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 14,
                    left: 20,
                    right: 20,
                  ),
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 0,
                    bottom: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // ✅ White background
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
                      // Label
                      const Text(
                        'OTP Code',
                        style: TextStyle(
                          color: Colors.black87, // ✅ Dark text
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // OTP Field
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        style: const TextStyle(
                          fontSize: 32,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // ✅ Dark input text
                        ),
                        decoration: InputDecoration(
                          hintText: '- - - - - -',
                          hintStyle: TextStyle(
                            letterSpacing: 16,
                            color: Colors.grey.shade400,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Verify button - Following OLD BlockButtonWidget design
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary, // ✅ Secondary background
                      foregroundColor: AppColors.primary, // ✅ Primary text
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      l10n.authVerify,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Resend OTP button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _isResending ? null : _sendOtp,
                      child: _isResending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.authResendOTP),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
        ],
      ),
    );
  }
}
