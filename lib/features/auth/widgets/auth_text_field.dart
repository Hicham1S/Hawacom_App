import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../constants/auth_styles.dart';

/// Reusable authentication text field widget
/// Provides consistent styling and structure across auth screens
class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AuthStyles.inputFieldPadding,
      margin: AuthStyles.inputFieldMargin,
      decoration: AuthStyles.inputFieldDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AuthStyles.labelTextStyle,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: AuthStyles.inputTextStyle,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AuthStyles.hintTextStyle,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(icon, color: AppColors.primary),
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
