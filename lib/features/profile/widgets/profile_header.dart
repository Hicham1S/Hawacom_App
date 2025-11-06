import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/user_profile.dart';

/// Profile header with avatar and user name
class ProfileHeader extends StatelessWidget {
  final UserProfile user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Stack(
          children: [
            _buildAvatar(),
            // Edit button (bottom-right corner)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // User Name
        Text(
          user.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // Email
        Text(
          user.email,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),

        // Location (if available)
        if (user.location != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                user.location!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      // Network image
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(user.avatarUrl!),
        backgroundColor: AppColors.cardBackground,
      );
    } else {
      // Initials placeholder
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primary,
        child: Text(
          user.initials,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
