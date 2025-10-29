import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/home/top_bar.dart';
import '../widgets/home/stories_section.dart';
import '../widgets/home/ai_banner.dart';
import '../widgets/home/quick_actions.dart';
import '../widgets/home/categories_section.dart';
import '../widgets/home/projects_gallery.dart';
import '../widgets/home/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    debugPrint('Bottom nav item tapped: $index');
    // TODO: Navigate to different screens based on index
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              // Main scrollable content
              Column(
                children: [
                  // Top Bar - Now from separate widget file
                  const TopBar(),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Stories Section
                          const SizedBox(height: 8),
                          const StoriesSection(),

                          // AI Banner
                          const AIBanner(),

                          // Quick Actions
                          const QuickActions(),

                          //CategoriesSection()
                          const CategoriesSection(),

                          //Project Gallery
                          const ProjectsGallery(),

                          // Extra space at bottom for floating navigation
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Bottom Navigation
              Positioned(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                bottom: 16,
                child: BottomNavigation(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
