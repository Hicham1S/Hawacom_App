import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../constants/auth_styles.dart';

/// Reusable authentication header widget
/// Provides consistent header design across auth screens
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.person_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: AuthStyles.headerDecoration,
          margin: const EdgeInsets.only(bottom: 50),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
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
          decoration: AuthStyles.logoDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 100,
              height: 100,
              color: AppColors.primary,
              child: Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
