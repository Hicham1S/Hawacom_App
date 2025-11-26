import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../providers/language_provider.dart';

/// Screen for selecting app language
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

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
            'اللغة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: LanguageProvider.availableLanguages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final language = LanguageProvider.availableLanguages[index];
                final languageCode = language['code']!;
                final languageName = language['name']!;
                final languageFlag = language['flag']!;
                final isSelected =
                    languageProvider.isLanguageSelected(languageCode);

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
                      await languageProvider.changeLanguage(languageCode);

                      // Show confirmation
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم تغيير اللغة إلى $languageName'),
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
                          // Flag emoji
                          Text(
                            languageFlag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 16),

                          // Language name
                          Expanded(
                            child: Text(
                              languageName,
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
