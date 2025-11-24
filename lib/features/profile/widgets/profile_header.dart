import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/user_model.dart';

/// Profile header with avatar and user name
class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  /// Get display name: user's name if available, otherwise phone number
  String get _displayName {
    if (user.name.isNotEmpty && !user.name.contains('@')) {
      return user.name;
    } else if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      return user.phoneNumber!;
    } else {
      return user.email;
    }
  }

  /// Get initials for avatar
  String get _initials {
    if (user.name.isNotEmpty && !user.name.contains('@')) {
      final parts = user.name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return user.name[0].toUpperCase();
    } else if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      return '#';
    } else {
      return user.email[0].toUpperCase();
    }
  }

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

        // User Name (or phone number if no name)
        Text(
          _displayName,
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

        // Address (if available)
        if (user.address != null && user.address!.isNotEmpty) ...[
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
              Flexible(
                child: Text(
                  user.address!,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      // Network image
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(user.photoUrl!),
        backgroundColor: AppColors.cardBackground,
      );
    } else {
      // Initials placeholder
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primary,
        child: Text(
          _initials,
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
