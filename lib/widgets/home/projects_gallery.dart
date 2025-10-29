import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../l10n/app_localizations.dart';

class ProjectsGallery extends StatelessWidget {
  const ProjectsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Project data
    final List<String> projects = [
      'assets/images/gallery1.png',
      'assets/images/gallery2.png',
      'assets/images/gallery3.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.projectsGallery,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              GestureDetector(
                onTap: _onViewAllTap,
                child: Text(
                  l10n.viewAll,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Scrolling Gallery
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(
                context,
                imagePath: projects[index],
                onTap: () => _onProjectTap(context, index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _onViewAllTap() {
    debugPrint('View All tapped - Show all projects');
    // TODO: Navigate to full projects page
  }

  void _onProjectTap(BuildContext context, int projectIndex) {
    debugPrint('Project tapped: Project ${projectIndex + 1}');
    // TODO: Navigate to project details page
  }
}