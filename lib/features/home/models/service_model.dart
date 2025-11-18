import 'category_model.dart';

/// Service (E-Service) model matching Laravel API response
class ServiceModel {
  final String id;
  final String name;
  final String? description;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final String? priceUnit;
  final String? quantityUnit;
  final double rate;
  final int totalReviews;
  final String? duration;
  final bool featured;
  final bool isFavorite;
  final List<CategoryModel>? categories;

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.images = const [],
    required this.price,
    this.discountPrice,
    this.priceUnit,
    this.quantityUnit,
    this.rate = 0.0,
    this.totalReviews = 0,
    this.duration,
    this.featured = false,
    this.isFavorite = false,
    this.categories,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Parse images - handle both array of objects and array of strings
    List<String> imageList = [];
    if (json['images'] != null) {
      final imgs = json['images'] as List;
      imageList = imgs.map((img) {
        if (img is Map && img['url'] != null) {
          return img['url'].toString();
        } else if (img is String) {
          return img;
        }
        return '';
      }).where((url) => url.isNotEmpty).toList();
    }

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      images: imageList,
      price: _parseDouble(json['price']),
      discountPrice: _parseDouble(json['discount_price']),
      priceUnit: json['price_unit'],
      quantityUnit: json['quantity_unit'],
      rate: _parseDouble(json['rate']),
      totalReviews: json['total_reviews'] ?? 0,
      duration: json['duration'],
      featured: json['featured'] == true || json['featured'] == 1,
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList()
          : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'images': images,
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      if (priceUnit != null) 'price_unit': priceUnit,
      if (quantityUnit != null) 'quantity_unit': quantityUnit,
      'rate': rate,
      'total_reviews': totalReviews,
      if (duration != null) 'duration': duration,
      'featured': featured,
      'is_favorite': isFavorite,
      if (categories != null)
        'categories': categories!.map((e) => e.toJson()).toList(),
    };
  }
}
