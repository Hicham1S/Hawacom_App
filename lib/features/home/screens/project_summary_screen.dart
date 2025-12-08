import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import 'agent_chat_screen.dart';

/// Screen showing project summary - to be implemented
class ProjectSummaryScreen extends StatelessWidget {
  const ProjectSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppLocalizations.of(context)!.projectSummaryTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // AI Robot Image
              Center(
                child: Image.asset(
                  'assets/images/Graident Ai Robot 1.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              // Welcome text
              Text(
                AppLocalizations.of(context)!.projectSummaryWelcome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Project Information Section
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppLocalizations.of(context)!.projectSummaryProjectInfo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category and Description Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category on the right
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.projectSummaryCategory,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.category,
                          color: AppColors.textSecondary,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Description on the left
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.projectSummaryDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textSecondary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.projectSummaryDescriptionPlaceholder,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Files and Photos Section
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppLocalizations.of(context)!.projectSummaryFilesPhotos,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Files placeholder
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.projectSummaryFilesPlaceholder,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Start new conversation button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AgentChatScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.projectSummaryStartConversation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
