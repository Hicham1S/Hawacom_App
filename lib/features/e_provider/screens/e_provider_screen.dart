import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/e_provider_provider.dart';
import '../models/e_provider_model.dart';
// TODO: Uncomment when implementing chat functionality:
// import '../../auth/providers/auth_provider.dart';
// import '../../messages/services/firebase_chat_service.dart';
// import '../../messages/screens/chat_screen.dart';

/// E-Provider detail screen
class EProviderScreen extends StatefulWidget {
  final String? eProviderId;
  final EProviderModel? eProvider;

  const EProviderScreen({
    super.key,
    this.eProviderId,
    this.eProvider,
  });

  @override
  State<EProviderScreen> createState() => _EProviderScreenState();
}

class _EProviderScreenState extends State<EProviderScreen> {
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
    });
  }

  Future<void> _initializeProvider() async {
    final provider = context.read<EProviderProvider>();

    if (widget.eProvider != null) {
      provider.setEProvider(widget.eProvider!);
      await provider.initialize(widget.eProvider!.id);
    } else if (widget.eProviderId != null) {
      await provider.initialize(widget.eProviderId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EProviderProvider>(
      builder: (context, provider, child) {
        // Loading state
        if (provider.isLoading || !provider.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (provider.hasError && !provider.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.eProviderError),
            ),
            body: Center(
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
                    provider.errorMessage ?? AppLocalizations.of(context)!.errorOccurred,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.eProviderRetry),
                  ),
                ],
              ),
            ),
          );
        }

        final eProvider = provider.eProvider!;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: CustomScrollView(
              slivers: [
                // App bar with image carousel
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildCarouselSlider(eProvider),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Provider info
                      _buildProviderInfo(eProvider, provider),

                      // Contact section
                      _buildContactSection(),

                      // Description
                      _buildDescriptionSection(eProvider),

                      // Availability
                      _buildAvailabilitySection(provider),

                      // Awards
                      if (provider.awards.isNotEmpty)
                        _buildAwardsSection(provider),

                      // Experiences
                      if (provider.experiences.isNotEmpty)
                        _buildExperiencesSection(provider),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarouselSlider(EProviderModel eProvider) {
    if (eProvider.images.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.business, size: 64, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            height: 300,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlide = index;
              });
            },
          ),
          items: eProvider.images.map((media) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  media.url,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
        // Carousel indicators
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: eProvider.images.asMap().entries.map((entry) {
              return Container(
                width: 20.0,
                height: 5.0,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _currentSlide == entry.key
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProviderInfo(
      EProviderModel eProvider, EProviderProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  eProvider.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (eProvider.type != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    eProvider.type!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (eProvider.verified)
            Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                const Text(
                  'موثق - Verified',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تواصل معنا - Contact us',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إذا كان لديك أي سؤال - If you have any question!',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _startChatWithProvider(context);
            },
            icon: Icon(
              Icons.chat_outlined,
              color: Theme.of(context).primaryColor,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(EProviderModel eProvider) {
    if (eProvider.description.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الوصف - Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Html(
            data: eProvider.description,
            style: {
              "body": Style(
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.5),
                color: AppColors.textSecondary,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "p": Style(
                margin: Margins.only(bottom: 8),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(EProviderProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'التوافر - Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: provider.isAvailable
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              provider.isAvailable
                  ? 'متاح - Available'
                  : 'غير متاح - Offline',
              style: TextStyle(
                fontSize: 12,
                color: provider.isAvailable ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(EProviderProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الجوائز - Awards',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...provider.awards.map((award) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    award.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    award.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildExperiencesSection(EProviderProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخبرات - Experiences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...provider.experiences.map((experience) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experience.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Prepare to start chat with provider
  /// TODO: When chat system is fully implemented, this will:
  /// 1. Get or create a conversation with the provider
  /// 2. Navigate to ChatScreen with the conversation
  void _startChatWithProvider(BuildContext context) {
    final provider = context.read<EProviderProvider>().eProvider;

    if (provider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('معلومات المزود غير متوفرة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement the following when chat system is ready:
    // 1. Get current user ID from AuthProvider
    // 2. Create or get existing conversation with provider using FirestoreChatService
    // 3. Navigate to ChatScreen with the conversation
    //
    // Example implementation:
    // final currentUserId = context.read<AuthProvider>().currentUser?.id;
    // if (currentUserId == null) return;
    //
    // final chatService = FirestoreChatService();
    // final conversation = await chatService.getOrCreateConversation(
    //   userId: currentUserId,
    //   providerId: provider.id,
    //   providerName: provider.name,
    // );
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => ChatScreen(conversation: conversation),
    //   ),
    // );

    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم فتح محادثة مع ${provider.name} قريباً'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

