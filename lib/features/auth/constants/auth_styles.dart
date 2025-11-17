import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Authentication UI styling constants
/// Provides consistent styling across auth screens
class AuthStyles {
  AuthStyles._(); // Private constructor to prevent instantiation

  // Input field decoration
  static BoxDecoration inputFieldDecoration = BoxDecoration(
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
  );

  // Input field padding
  static const EdgeInsets inputFieldPadding = EdgeInsets.only(
    top: 20,
    bottom: 14,
    left: 20,
    right: 20,
  );

  // Input field margin
  static const EdgeInsets inputFieldMargin = EdgeInsets.only(
    left: 20,
    right: 20,
    bottom: 14,
  );

  // Label text style
  static const TextStyle labelTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Input text style
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  // Hint text style
  static TextStyle hintTextStyle = TextStyle(
    color: Colors.grey.shade400,
  );

  // Header decoration
  static BoxDecoration headerDecoration = BoxDecoration(
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
  );

  // Button style
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 2,
  );

  // Button text style
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Logo circle decoration
  static BoxDecoration logoDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(14),
    border: Border.all(width: 5, color: AppColors.primary),
    color: Colors.white,
  );

  // Error container decoration
  static BoxDecoration errorDecoration = BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.red.shade200),
  );
}
