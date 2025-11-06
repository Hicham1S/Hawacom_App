import '../models/story.dart';
import '../models/story_segment.dart';
import '../../home/models/category.dart';
import '../../home/models/project.dart';
import '../../home/models/announcement.dart';

class MockData {
  // Stories Data
  // Stories can contain mixed media: images and videos
  // For videos, use StoryMediaType.video and provide a video URL
  // Supported formats: MP4 (H.264), network URLs or local assets
  // Example video URLs are provided below using Google's test videos
  static List<Story> getStories() {
    return [
      // Add Story button (always first)
      Story(
        id: 'add',
        userName: 'أضف ستوري',
        userImage: 'assets/images/Me.png',
        isAddStory: true,
        hasStory: false,
        segments: [],
      ),

      // Amina's story - Multiple segments with live badge
      Story(
        id: '1',
        userName: 'أمينة الهاجري',
        userImage: 'assets/images/Amina.png',
        isLive: true,
        hasStory: true,
        segments: [
          StorySegment(
            id: '1-1',
            mediaUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
          StorySegment(
            id: '1-2',
            mediaUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
          StorySegment(
            id: '1-3',
            mediaUrl: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
        ],
      ),

      // Ahmad's story - Single segment
      Story(
        id: '2',
        userName: 'أحمد الشهري',
        userImage: 'assets/images/Ahmad.png',
        hasStory: true,
        segments: [
          StorySegment(
            id: '2-1',
            mediaUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
          StorySegment(
            id: '2-2',
            mediaUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
        ],
      ),

      // Mohammed's story - Mixed media with video!
      Story(
        id: '3',
        userName: 'محمد علي',
        userImage: 'assets/images/Me.png',
        hasStory: true,
        segments: [
          // Image segment
          StorySegment(
            id: '3-1',
            mediaUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
          // Video segment - Short sample video (10 seconds)
          StorySegment(
            id: '3-2',
            mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            mediaType: StoryMediaType.video,
            duration: const Duration(seconds: 15), // Will be auto-detected, max 60s
          ),
          // Another image
          StorySegment(
            id: '3-3',
            mediaUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
        ],
      ),

      // Sarah's story - Already viewed with video
      Story(
        id: '4',
        userName: 'سارة أحمد',
        userImage: 'assets/images/Amina.png',
        hasStory: true,
        isViewed: true,
        segments: [
          // Image
          StorySegment(
            id: '4-1',
            mediaUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
          // Video segment - Another short video (15 seconds)
          StorySegment(
            id: '4-2',
            mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
            mediaType: StoryMediaType.video,
            duration: const Duration(seconds: 15), // Will be auto-detected, max 60s
          ),
          // Another image
          StorySegment(
            id: '4-3',
            mediaUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800',
            mediaType: StoryMediaType.image,
            duration: const Duration(seconds: 5),
          ),
        ],
      ),
    ];
  }

  // Categories Data
  static List<Category> getCategories() {
    return [
      Category(
        id: '1',
        name: 'تصميم معماري',
        iconPath: 'assets/images/icons/architecture.svg',
      ),
      Category(
        id: '2',
        name: 'سوشال ميديا',
        iconPath: 'assets/images/icons/social-media.svg',
      ),
      Category(
        id: '3',
        name: 'ديكور داخلي',
        iconPath: 'assets/images/icons/interior.svg',
      ),
      Category(
        id: '4',
        name: 'تصميم أزياء',
        iconPath: 'assets/images/icons/fashion.svg',
      ),
      Category(
        id: '5',
        name: 'هويات',
        iconPath: 'assets/images/icons/branding.svg',
      ),
      Category(
        id: '6',
        name: 'موشن جرافيك',
        iconPath: 'assets/images/icons/motion.svg',
      ),
      Category(
        id: '7',
        name: 'تصوير فوتوغرافي',
        iconPath: 'assets/images/icons/photography.svg',
      ),
      Category(
        id: '8',
        name: 'رسم توضيحي',
        iconPath: 'assets/images/icons/illustration.svg',
      ),
    ];
  }

  // Projects Data
  static List<Project> getProjects() {
    return [
      Project(
        id: '1',
        title: 'مبنى معماري حديث',
        imageUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=400',
        category: 'تصميم معماري',
        author: 'أحمد الشهري',
      ),
      Project(
        id: '2',
        title: 'تصميم هوية بصرية',
        imageUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400',
        category: 'هويات',
        author: 'فاطمة العتيبي',
      ),
      Project(
        id: '3',
        title: 'تصميم داخلي فاخر',
        imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400',
        category: 'ديكور داخلي',
        author: 'سارة المالكي',
      ),
      Project(
        id: '4',
        title: 'حملة سوشال ميديا',
        imageUrl: 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400',
        category: 'سوشال ميديا',
        author: 'محمد الدوسري',
      ),
      Project(
        id: '5',
        title: 'تصميم أزياء عصري',
        imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea2f46aa?w=400',
        category: 'تصميم أزياء',
        author: 'نورة القحطاني',
      ),
      Project(
        id: '6',
        title: 'موشن جرافيك إبداعي',
        imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400',
        category: 'موشن جرافيك',
        author: 'خالد العنزي',
      ),
      Project(
        id: '7',
        title: 'جلسة تصوير احترافية',
        imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400',
        category: 'تصوير فوتوغرافي',
        author: 'ريم الزهراني',
      ),
      Project(
        id: '8',
        title: 'رسم توضيحي رقمي',
        imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=400',
        category: 'رسم توضيحي',
        author: 'عبدالله الغامدي',
      ),
      Project(
        id: '9',
        title: 'فيلا معمارية فخمة',
        imageUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400',
        category: 'تصميم معماري',
        author: 'أمينة الهاجري',
      ),
      Project(
        id: '10',
        title: 'تصميم واجهة تطبيق',
        imageUrl: 'https://images.unsplash.com/photo-1561070791-36c11767b26a?w=400',
        category: 'هويات',
        author: 'يوسف الحربي',
      ),
    ];
  }

  // Announcements Data
  static List<Announcement> getAnnouncements() {
    return [
      Announcement(
        id: '1',
        title: 'لدينا مشروع تصميم الآن!',
        icon: '🎨',
      ),
      Announcement(
        id: '2',
        title: 'احتاج مصور عبر الذكاء الاصطناعي',
        icon: '🤖',
      ),
    ];
  }

  // AI Banner Data
  static Map<String, String> getAIBanner() {
    return {
      'title': 'الذكاء الاصطناعي',
      'subtitle': 'اعرف ما يبدو التصميم متوافقة معضلة',
      'buttonText': 'اضغط هنا',
      'imageUrl': 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400',
    };
  }
}
