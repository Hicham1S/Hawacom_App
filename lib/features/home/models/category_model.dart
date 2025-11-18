/// Category model matching Laravel API response
class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final String? imageUrl;
  final bool featured;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.color,
    this.imageUrl,
    this.featured = false,
    this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Helper function to extract string from multilingual field
    String extractString(dynamic field, [String defaultValue = '']) {
      if (field == null) return defaultValue;
      if (field is String) return field;
      if (field is Map) {
        // Try Arabic first, then English, then any value
        return field['ar']?.toString() ??
               field['en']?.toString() ??
               field.values.firstWhere((v) => v != null, orElse: () => defaultValue)?.toString() ??
               defaultValue;
      }
      return field.toString();
    }

    // Extract image URL from media array or image field
    String? getImageUrl() {
      String? url;

      // Check media array first
      if (json['media'] is List && (json['media'] as List).isNotEmpty) {
        final media = (json['media'] as List).first;
        if (media is Map) {
          url = media['url'] ?? media['thumb'] ?? media['icon'];
        }
      }
      // Fallback to image field
      if (url == null && json['image'] is Map) {
        url = json['image']['url'];
      } else if (url == null && json['image'] is String) {
        url = json['image'];
      }

      // Fix old domain URLs (hawwcom.com -> hawacom.sa)
      if (url != null) {
        url = url.replaceAll('hawwcom.com', 'hawacom.sa');
        url = url.replaceAll('http://', 'https://'); // Ensure HTTPS
      }

      return url;
    }

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: extractString(json['name']),
      description: extractString(json['description'], ''),
      color: json['color'],
      imageUrl: getImageUrl(),
      featured: json['featured'] == true || json['featured'] == 1,
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (imageUrl != null) 'image': imageUrl,
      'featured': featured,
      if (subCategories != null)
        'sub_categories': subCategories!.map((e) => e.toJson()).toList(),
    };
  }
}
