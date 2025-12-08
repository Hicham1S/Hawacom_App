import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/theme_provider.dart';

/// Screen for selecting app theme mode
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

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
            'المظهر',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ThemeProvider.availableThemeModes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final themeInfo = ThemeProvider.availableThemeModes[index];
                final themeMode = themeInfo['mode'] as ThemeMode;
                final themeName = themeInfo['name'] as String;
                final themeIcon = themeInfo['icon'] as IconData;
                final isSelected = themeProvider.isThemeModeSelected(themeMode);

                Color iconColor;
                switch (themeMode) {
                  case ThemeMode.light:
                    iconColor = Colors.orange;
                    break;
                  case ThemeMode.dark:
                    iconColor = Colors.indigo;
                    break;
                  case ThemeMode.system:
                    iconColor = Colors.blue;
                    break;
                }

                return Card(
                  elevation: isSelected ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: AppColors.primary, width: 2)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await themeProvider.changeThemeMode(themeMode);

                      // Show confirmation
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.settingsThemeChanged(themeName)),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              themeIcon,
                              color: iconColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Theme name
                          Expanded(
                            child: Text(
                              themeName,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),

                          // Selected indicator
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
