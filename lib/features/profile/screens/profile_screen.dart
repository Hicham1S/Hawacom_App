import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_stats.dart';

/// User profile screen
/// Displays user information, stats, and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ProfileService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            l10n.profileTitle,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
              onPressed: () {
                // TODO: Navigate to settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.profileSettingsComingSoon)),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _user == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.profileLoadError,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(l10n.profileRetry),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadProfile,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile Header
                          ProfileHeader(user: _user!),

                          const SizedBox(height: 24),

                          // Stats
                          ProfileStats(
                            projectsCount: _user!.projectsCount,
                            followersCount: _user!.followersCount,
                            followingCount: _user!.followingCount,
                          ),

                          const SizedBox(height: 24),

                          // Information Section
                          _buildSectionTitle(l10n.profileInformation),

                          const SizedBox(height: 12),

                          // Email
                          ProfileInfoTile(
                            icon: Icons.email_outlined,
                            title: l10n.profileEmail,
                            value: _user!.email,
                          ),

                          // Phone (if available)
                          if (_user!.phone != null)
                            ProfileInfoTile(
                              icon: Icons.phone_outlined,
                              title: l10n.profilePhone,
                              value: _user!.phone!,
                            ),

                          // Member since
                          ProfileInfoTile(
                            icon: Icons.calendar_today_outlined,
                            title: l10n.profileMemberSince,
                            value: _formatDate(_user!.createdAt),
                          ),

                          const SizedBox(height: 24),

                          // Actions Section
                          _buildSectionTitle(l10n.profileActions),

                          const SizedBox(height: 12),

                          ProfileInfoTile(
                            icon: Icons.edit_outlined,
                            title: l10n.profileEditProfile,
                            value: l10n.profileEditProfileDesc,
                            onTap: () {
                              // TODO: Navigate to edit profile
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.profileEditComingSoon)),
                              );
                            },
                          ),

                          ProfileInfoTile(
                            icon: Icons.location_on_outlined,
                            title: 'عناويني',
                            value: 'إدارة عناوين التوصيل',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.addresses);
                            },
                          ),

                          ProfileInfoTile(
                            icon: Icons.security_outlined,
                            title: l10n.profileChangePassword,
                            value: l10n.profileChangePasswordDesc,
                            onTap: () {
                              // TODO: Navigate to change password
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.profilePasswordComingSoon)),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _showLogoutDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout_rounded, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.menuLogout,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context)!;
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
              Navigator.pop(context); // Return to previous screen
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
