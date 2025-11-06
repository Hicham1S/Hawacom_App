import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';

/// Profile statistics row (projects, followers, following)
class ProfileStats extends StatelessWidget {
  final int projectsCount;
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    super.key,
    required this.projectsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: l10n.profileProjects,
            value: projectsCount,
          ),
          _buildDivider(),
          _buildStatItem(
            label: l10n.profileFollowers,
            value: followersCount,
          ),
          _buildDivider(),
          _buildStatItem(
            label: l10n.profileFollowing,
            value: followingCount,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String label, required int value}) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.textSecondary.withValues(alpha: 0.2),
    );
  }
}
