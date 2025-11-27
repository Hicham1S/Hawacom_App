import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/help_provider.dart';

/// Help screen with FAQ categories and expandable questions
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHelp();
    });
  }

  Future<void> _initializeHelp() async {
    final provider = context.read<HelpProvider>();
    await provider.initialize();

    // Initialize tab controller after categories are loaded
    if (mounted && provider.categories.isNotEmpty) {
      setState(() {
        _tabController = TabController(
          length: provider.categories.length,
          vsync: this,
        );

        // Listen to tab changes
        _tabController?.addListener(() {
          if (_tabController!.indexIsChanging) {
            final categoryId =
                provider.categories[_tabController!.index].id;
            provider.loadFaqsForCategory(categoryId);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Consumer<HelpProvider>(
      builder: (context, provider, child) {
        // Recreate tab controller if categories changed
        if (provider.categories.isNotEmpty) {
          if (_tabController == null ||
              _tabController!.length != provider.categories.length) {
            _tabController = TabController(
              length: provider.categories.length,
              vsync: this,
            );

            _tabController?.addListener(() {
              if (_tabController!.indexIsChanging) {
                final categoryId =
                    provider.categories[_tabController!.index].id;
                provider.loadFaqsForCategory(categoryId);
              }
            });
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('مساعدة - Help'),
            bottom: provider.categories.isEmpty
                ? null
                : TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: provider.categories
                        .map((category) => Tab(text: category.name))
                        .toList(),
                  ),
          ),
          body: _buildBody(provider, primaryColor),
        );
      },
    );
  }

  Widget _buildBody(HelpProvider provider, Color primaryColor) {
    // Loading categories
    if (provider.isLoadingCategories) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error loading categories
    if (provider.hasError && provider.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'حدث خطأ - An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة - Retry'),
            ),
          ],
        ),
      );
    }

    // No categories
    if (provider.categories.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد فئات متاحة\nNo categories available',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // Tab view with FAQs
    return TabBarView(
      controller: _tabController,
      children: provider.categories.map((category) {
        return _buildFaqList(provider, primaryColor);
      }).toList(),
    );
  }

  Widget _buildFaqList(HelpProvider provider, Color primaryColor) {
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: Builder(
        builder: (context) {
          // Loading FAQs
          if (provider.isLoadingFaqs) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error loading FAQs
          if (provider.hasError && provider.faqs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'حدث خطأ - An error occurred',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة - Retry'),
                  ),
                ],
              ),
            );
          }

          // No FAQs
          if (provider.faqs.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'لا توجد أسئلة متاحة\nNo questions available',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }

          // FAQs list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.faqs.length,
            itemBuilder: (context, index) {
              final faq = provider.faqs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.help_outline,
                        color: primaryColor,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          faq.answer,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
