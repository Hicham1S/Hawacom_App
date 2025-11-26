import 'package:equatable/equatable.dart';
import '../../services/models/service_model.dart';

/// Model representing a favorited service
class FavoriteModel extends Equatable {
  final String id;
  final ServiceModel service;
  final String userId;
  final DateTime createdAt;

  const FavoriteModel({
    required this.id,
    required this.service,
    required this.userId,
    required this.createdAt,
  });

  /// Create from JSON
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id']?.toString() ?? '',
      service: ServiceModel.fromJson(json['e_service'] ?? {}),
      userId: json['user_id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'e_service_id': service.id,
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [id];
}
