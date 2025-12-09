import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/language_provider.dart';

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
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 20,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.2),
                      iconColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
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
