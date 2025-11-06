// Detailed project data with descriptions, tags, and metadata

class ProjectDetail {
  final String projectId;
  final String description;
  final List<String> tags;
  final int likes;
  final int views;
  final int comments;
  final DateTime createdAt;

  ProjectDetail({
    required this.projectId,
    required this.description,
    required this.tags,
    required this.likes,
    required this.views,
    required this.comments,
    required this.createdAt,
  });
}

class ProjectDetails {
  static List<ProjectDetail> getProjectDetails() {
    return [
      ProjectDetail(
        projectId: '1',
        description: 'تصميم معماري حديث لمبنى سكني فاخر يجمع بين الأصالة والحداثة',
        tags: ['معماري', 'حديث', 'فاخر', 'سكني'],
        likes: 1250,
        views: 8500,
        comments: 45,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      ProjectDetail(
        projectId: '2',
        description: 'هوية بصرية متكاملة لشركة ناشئة في مجال التقنية',
        tags: ['هوية', 'برanding', 'شعار', 'ألوان'],
        likes: 890,
        views: 5600,
        comments: 32,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      ProjectDetail(
        projectId: '3',
        description: 'تصميم داخلي راقي لفيلا سكنية بمساحة 500 متر مربع',
        tags: ['ديكور', 'داخلي', 'فخم', 'مودرن'],
        likes: 2100,
        views: 12000,
        comments: 67,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      ProjectDetail(
        projectId: '4',
        description: 'حملة تسويقية على منصات التواصل الاجتماعي لمنتج تقني جديد',
        tags: ['سوشال', 'تسويق', 'حملة', 'إعلان'],
        likes: 1450,
        views: 9800,
        comments: 52,
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
      ),
      ProjectDetail(
        projectId: '5',
        description: 'تصميم مجموعة أزياء عصرية مستوحاة من التراث السعودي',
        tags: ['أزياء', 'موضة', 'عصري', 'تراثي'],
        likes: 3200,
        views: 18000,
        comments: 98,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      ProjectDetail(
        projectId: '6',
        description: 'موشن جرافيك احترافي لفيديو توضيحي عن خدمة رقمية',
        tags: ['موشن', 'أنيميشن', 'فيديو', 'توضيحي'],
        likes: 1680,
        views: 11500,
        comments: 41,
        createdAt: DateTime.now().subtract(Duration(days: 4)),
      ),
      ProjectDetail(
        projectId: '7',
        description: 'جلسة تصوير احترافية لمنتجات تجارية في الاستوديو',
        tags: ['تصوير', 'منتجات', 'احترافي', 'استوديو'],
        likes: 980,
        views: 6700,
        comments: 28,
        createdAt: DateTime.now().subtract(Duration(days: 6)),
      ),
      ProjectDetail(
        projectId: '8',
        description: 'رسومات توضيحية رقمية لكتاب أطفال تعليمي',
        tags: ['رسم', 'توضيحي', 'أطفال', 'تعليمي'],
        likes: 1120,
        views: 7200,
        comments: 35,
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
      ProjectDetail(
        projectId: '9',
        description: 'تصميم فيلا معمارية فخمة على الطراز النيوكلاسيكي',
        tags: ['معماري', 'فيلا', 'كلاسيكي', 'فخم'],
        likes: 2450,
        views: 15000,
        comments: 72,
        createdAt: DateTime.now().subtract(Duration(hours: 8)),
      ),
      ProjectDetail(
        projectId: '10',
        description: 'تصميم واجهة مستخدم لتطبيق جوال في مجال التجارة الإلكترونية',
        tags: ['UI', 'UX', 'تطبيق', 'موبايل'],
        likes: 1890,
        views: 10500,
        comments: 56,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];
  }

  static List<String> getAllTags() {
    return [
      'معماري',
      'ديكور',
      'داخلي',
      'هوية',
      'برanding',
      'سوشال',
      'تسويق',
      'أزياء',
      'موضة',
      'موشن',
      'أنيميشن',
      'تصوير',
      'فوتوغرافي',
      'رسم',
      'توضيحي',
      'UI',
      'UX',
      'تطبيق',
      'ويب',
      'جرافيك',
      'شعار',
      'طباعة',
      'إعلان',
      'حديث',
      'كلاسيكي',
      'مودرن',
      'فخم',
      'بسيط',
      'ملون',
      'أحادي اللون',
    ];
  }
}
