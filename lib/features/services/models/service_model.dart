import '../../../core/models/base_model.dart';
import '../../home/models/category_model.dart';
import 'media_model.dart';

/// Service (E-Service) model for the services feature
class ServiceModel extends BaseModel {
  final String id;
  final String name;
  final String? description;
  final List<MediaModel> media;
  final double price;
  final double? discountPrice;
  final String? priceUnit;
  final String? quantityUnit;
  final double rate;
  final int totalReviews;
  final String? duration;
  final bool featured;
  final bool isFavorite;
  final String? favoriteId; // ID of the favorite record (if favorited)
  final List<CategoryModel> categories;
  final String? providerId;
  final String? providerName;

  const ServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.media = const [],
    required this.price,
    this.discountPrice,
    this.priceUnit,
    this.quantityUnit,
    this.rate = 0.0,
    this.totalReviews = 0,
    this.duration,
    this.featured = false,
    this.isFavorite = false,
    this.favoriteId,
    this.categories = const [],
    this.providerId,
    this.providerName,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Helper function to extract string from multilingual field
    String extractString(dynamic field, [String defaultValue = '']) {
      if (field == null) return defaultValue;
      if (field is String) return field;
      if (field is Map) {
        return field['ar']?.toString() ??
            field['en']?.toString() ??
            field.values
                .firstWhere((v) => v != null, orElse: () => defaultValue)
                ?.toString() ??
            defaultValue;
      }
      return field.toString();
    }

    // Parse media/images
    List<MediaModel> mediaList = [];
    if (json['media'] is List) {
      mediaList = (json['media'] as List)
          .map((m) => MediaModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } else if (json['images'] is List) {
      mediaList = (json['images'] as List)
          .map((m) => MediaModel.fromJson(m as Map<String, dynamic>))
          .toList();
    }

    // Parse categories
    List<CategoryModel> categoryList = [];
    if (json['categories'] is List) {
      categoryList = (json['categories'] as List)
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    // Parse double safely
    double parseDouble(dynamic value, [double defaultValue = 0.0]) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    // Parse int safely
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    // Parse bool safely
    bool parseBool(dynamic value, [bool defaultValue = false]) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return defaultValue;
    }

    // Get provider info
    String? providerId;
    String? providerName;
    if (json['e_provider'] is Map) {
      final provider = json['e_provider'] as Map<String, dynamic>;
      providerId = provider['id']?.toString();
      providerName = extractString(provider['name']);
    }

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: extractString(json['name']),
      description: extractString(json['description']),
      media: mediaList,
      price: parseDouble(json['price']),
      discountPrice: parseDouble(json['discount_price']),
      priceUnit: json['price_unit']?.toString(),
      quantityUnit: extractString(json['quantity_unit']),
      rate: parseDouble(json['rate']),
      totalReviews: parseInt(json['total_reviews']),
      duration: json['duration']?.toString(),
      featured: parseBool(json['featured']),
      isFavorite: parseBool(json['is_favorite']),
      favoriteId: json['favorite_id']?.toString(),
      categories: categoryList,
      providerId: providerId,
      providerName: providerName,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'media': media.map((m) => m.toJson()).toList(),
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      if (priceUnit != null) 'price_unit': priceUnit,
      if (quantityUnit != null) 'quantity_unit': quantityUnit,
      'rate': rate,
      'total_reviews': totalReviews,
      if (duration != null) 'duration': duration,
      'featured': featured,
      'is_favorite': isFavorite,
      if (favoriteId != null) 'favorite_id': favoriteId,
      'categories': categories.map((c) => c.toJson()).toList(),
      if (providerId != null) 'e_provider_id': providerId,
    };
  }

  /// Get the actual price (discount price if available, otherwise regular price)
  double get actualPrice => (discountPrice != null && discountPrice! > 0)
      ? discountPrice!
      : price;

  /// Check if service has discount
  bool get hasDiscount =>
      discountPrice != null && discountPrice! > 0 && discountPrice! < price;

  /// Get price unit text
  String get priceUnitText {
    if (priceUnit == 'fixed') {
      return quantityUnit?.isNotEmpty == true ? '/$quantityUnit' : '';
    } else if (priceUnit == 'hourly') {
      return '/ساعة';
    }
    return '';
  }

  /// Get first media URL
  String? get firstImageUrl => media.isNotEmpty ? media.first.url : null;

  /// Get first thumbnail URL
  String? get firstThumbUrl => media.isNotEmpty ? media.first.thumb : null;

  /// Copy with method
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    List<MediaModel>? media,
    double? price,
    double? discountPrice,
    String? priceUnit,
    String? quantityUnit,
    double? rate,
    int? totalReviews,
    String? duration,
    bool? featured,
    bool? isFavorite,
    String? favoriteId,
    List<CategoryModel>? categories,
    String? providerId,
    String? providerName,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      media: media ?? this.media,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      priceUnit: priceUnit ?? this.priceUnit,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      rate: rate ?? this.rate,
      totalReviews: totalReviews ?? this.totalReviews,
      duration: duration ?? this.duration,
      featured: featured ?? this.featured,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteId: favoriteId ?? this.favoriteId,
      categories: categories ?? this.categories,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        media,
        price,
        discountPrice,
        priceUnit,
        quantityUnit,
        rate,
        totalReviews,
        duration,
        featured,
        isFavorite,
        favoriteId,
        categories,
        providerId,
        providerName,
      ];
}
