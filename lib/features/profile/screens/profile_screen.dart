import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../favorites/providers/favorite_provider.dart';
import '../../services/providers/service_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';

/// User profile screen
/// Displays user information, stats, and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();

      // Ensure AuthProvider is initialized
      if (!authProvider.isInitialized) {
        await authProvider.initialize();
      }

      // Refresh user data from API if possible
      // This will update the currentUser in AuthProvider
    } catch (e) {
      debugPrint('Error refreshing profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.profileSettingsComingSoon)),
                );
              },
            ),
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;

            if (_isLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (user == null) {
              return Center(
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
                      onPressed: _refreshProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(l10n.profileRetry),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshProfile,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Header
                    ProfileHeader(user: user),

                    const SizedBox(height: 24),

                    // Information Section
                    _buildSectionTitle(l10n.profileInformation),

                    const SizedBox(height: 12),

                    // Email
                    ProfileInfoTile(
                      icon: Icons.email_outlined,
                      title: l10n.profileEmail,
                      value: user.email,
                    ),

                    // Phone (if available)
                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                      ProfileInfoTile(
                        icon: Icons.phone_outlined,
                        title: l10n.profilePhone,
                        value: user.phoneNumber!,
                      ),

                    // Member since (if available)
                    if (user.createdAt != null)
                      ProfileInfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: l10n.profileMemberSince,
                        value: _formatDate(user.createdAt!),
                      ),

                    const SizedBox(height: 24),

                    // Actions Section
                    _buildSectionTitle(l10n.profileActions),

                    const SizedBox(height: 12),

                    ProfileInfoTile(
                      icon: Icons.edit_outlined,
                      title: l10n.profileEditProfile,
                      value: l10n.profileEditProfileDesc,
                      onTap: () async {
                        await Navigator.pushNamed(context, AppRoutes.editProfile);
                        // Reload profile after edit
                        _refreshProfile();
                      },
                    ),

                    ProfileInfoTile(
                      icon: Icons.security_outlined,
                      title: l10n.profileChangePassword,
                      value: l10n.profileChangePasswordDesc,
                      onTap: () async {
                        await Navigator.pushNamed(context, AppRoutes.editProfile);
                        _refreshProfile();
                      },
                    ),

                    ProfileInfoTile(
                      icon: Icons.bookmark_outline,
                      title: l10n.profileMyBookings,
                      value: l10n.profileViewBookings,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.myBookings);
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
            );
          },
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
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _handleLogout();
            },
            child: Text(
              l10n.menuLogout,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }

      // Get providers and logout
      final authProvider = context.read<AuthProvider>();
      final favoriteProvider = context.read<FavoriteProvider>();
      final serviceProvider = context.read<ServiceProvider>();

      // Clear all provider states to prevent cross-account contamination
      await authProvider.logout();
      favoriteProvider.clearState();
      serviceProvider.clearState();

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Navigate to login screen and clear all previous routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );

      // Show success message
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authLogoutSuccess),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Logout error: $e');

      if (!mounted) return;

      // Try to close loading dialog if it's showing
      try {
        Navigator.pop(context);
      } catch (_) {}

      // Show error message
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.authLogoutFailed}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
