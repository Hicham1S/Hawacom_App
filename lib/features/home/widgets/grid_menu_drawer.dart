import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../profile/screens/profile_screen.dart';

/// Right-side drawer menu that slides in when grid button is tapped
class GridMenuDrawer extends StatelessWidget {
  const GridMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, l10n),

            const SizedBox(height: 8),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.home_rounded,
                    title: l10n.menuHome,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to home
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: l10n.menuProfile,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite_border_rounded,
                    title: l10n.menuFavorites,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to favorites
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.bookmark_border_rounded,
                    title: l10n.menuSaved,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to saved items
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.work_outline_rounded,
                    title: l10n.menuProjects,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to projects
                    },
                  ),
                  const Divider(height: 32, thickness: 1),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: l10n.menuSettings,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: l10n.menuHelp,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to help
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: l10n.menuAbout,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to about
                    },
                  ),
                ],
              ),
            ),

            // Footer - Logout
            _buildLogoutButton(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.menuWelcome,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.menuUserName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: AppColors.cardBackground,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.cardBackground,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.redAccent,
          size: 24,
        ),
        title: Text(
          l10n.menuLogout,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          // Handle logout
          _showLogoutDialog(context, l10n);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          l10n.menuLogout,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.menuLogoutConfirm,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
