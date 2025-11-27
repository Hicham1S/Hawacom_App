import 'package:equatable/equatable.dart';

/// Model for service reviews/ratings
class ReviewModel extends Equatable {
  final String id;
  final double rate;
  final String review;
  final DateTime createdAt;
  final String? userId;
  final String? userName;
  final String? userPhotoUrl;
  final String? serviceId;
  final String? serviceName;

  const ReviewModel({
    required this.id,
    required this.rate,
    required this.review,
    required this.createdAt,
    this.userId,
    this.userName,
    this.userPhotoUrl,
    this.serviceId,
    this.serviceName,
  });

  /// Create from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Parse user info
    String? userId;
    String? userName;
    String? userPhotoUrl;

    if (json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      userId = user['id']?.toString();
      userName = user['name']?.toString();

      // Parse user photo
      if (user['avatar'] is Map) {
        userPhotoUrl = user['avatar']['url'];
      } else if (user['avatar'] is String) {
        userPhotoUrl = user['avatar'];
      } else if (user['media'] is List && (user['media'] as List).isNotEmpty) {
        final media = (user['media'] as List).first;
        if (media is Map) {
          userPhotoUrl = media['url'];
        }
      }
    }

    // Parse service info
    String? serviceId;
    String? serviceName;

    if (json['e_service'] is Map) {
      final service = json['e_service'] as Map<String, dynamic>;
      serviceId = service['id']?.toString();

      // Extract service name from multilingual field
      if (service['name'] is Map) {
        final nameMap = service['name'] as Map;
        serviceName = nameMap['ar'] ?? nameMap['en'] ?? nameMap.values.first;
      } else {
        serviceName = service['name']?.toString();
      }
    }

    return ReviewModel(
      id: json['id']?.toString() ?? '',
      rate: _parseDouble(json['rate']),
      review: json['review']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      serviceId: serviceId,
      serviceName: serviceName,
    );
  }

  /// Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'rate': rate,
      'review': review,
      if (userId != null) 'user_id': userId,
      if (serviceId != null) 'e_service_id': serviceId,
    };
  }

  /// Helper to parse double from various formats
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  /// Copy with method
  ReviewModel copyWith({
    String? id,
    double? rate,
    String? review,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? serviceId,
    String? serviceName,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      rate: rate ?? this.rate,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        rate,
        review,
        createdAt,
        userId,
        serviceId,
      ];
}
