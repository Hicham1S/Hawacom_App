import 'package:flutter/material.dart';
import '../constants/auth_styles.dart';

/// Reusable error message widget for authentication screens
class AuthErrorMessage extends StatelessWidget {
  final String message;

  const AuthErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: AuthStyles.errorDecoration,
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade900, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
