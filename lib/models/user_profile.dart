import 'package:equatable/equatable.dart';

/// User profile model
/// Represents authenticated user's profile information
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? location;
  final DateTime createdAt;
  final int projectsCount;
  final int followersCount;
  final int followingCount;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.location,
    DateTime? createdAt,
    this.projectsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create UserProfile from JSON (for API integration later)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      location: json['location'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      projectsCount: json['projectsCount'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
    );
  }

  /// Convert UserProfile to JSON (for API integration later)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'projectsCount': projectsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? location,
    int? projectsCount,
    int? followersCount,
    int? followingCount,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      createdAt: createdAt,
      projectsCount: projectsCount ?? this.projectsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }

  /// Get initials from name (for avatar placeholder)
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  /// Equatable: Compare by id
  @override
  List<Object?> get props => [id];
}
