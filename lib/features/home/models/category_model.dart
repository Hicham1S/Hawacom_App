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
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      color: json['color'],
      imageUrl: json['image'] is Map ? json['image']['url'] : json['image'],
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
