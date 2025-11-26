import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

/// Main settings screen with navigation to sub-settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'الإعدادات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Language Setting
            _buildSettingCard(
              context,
              title: 'اللغة',
              subtitle: context.watch<LanguageProvider>().getLanguageName(
                    context.watch<LanguageProvider>().currentLanguageCode,
                  ),
              icon: Icons.language,
              iconColor: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.languageSettings);
              },
            ),

            const SizedBox(height: 12),

            // Theme Setting
            _buildSettingCard(
              context,
              title: 'المظهر',
              subtitle: context.watch<ThemeProvider>().getThemeModeName(
                    context.watch<ThemeProvider>().themeMode,
                  ),
              icon: Icons.brightness_6,
              iconColor: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.themeSettings);
              },
            ),

            const SizedBox(height: 12),

            // Profile Settings
            _buildSettingCard(
              context,
              title: 'الملف الشخصي',
              subtitle: 'تعديل معلومات الحساب',
              icon: Icons.person,
              iconColor: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
            ),

            const SizedBox(height: 12),

            // Addresses
            _buildSettingCard(
              context,
              title: 'العناوين',
              subtitle: 'إدارة عناوين التوصيل',
              icon: Icons.location_on,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addresses);
              },
            ),

            const SizedBox(height: 24),

            // Section: About
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'حول التطبيق',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _buildSettingCard(
              context,
              title: 'من نحن',
              subtitle: 'معلومات عن التطبيق',
              icon: Icons.info_outline,
              iconColor: Colors.orange,
              onTap: () {
                // Navigate to about page
              },
            ),

            const SizedBox(height: 12),

            _buildSettingCard(
              context,
              title: 'الشروط والأحكام',
              subtitle: 'شروط استخدام الخدمة',
              icon: Icons.description,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.terms);
              },
            ),

            const SizedBox(height: 12),

            _buildSettingCard(
              context,
              title: 'سياسة الخصوصية',
              subtitle: 'كيف نحمي بياناتك',
              icon: Icons.privacy_tip,
              iconColor: Colors.indigo,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacy);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_back_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
