import 'package:equatable/equatable.dart';

/// Enhanced user model with Laravel API fields including role/position
class UserModelEnhanced extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? apiToken;
  final String? deviceToken;
  final String? photoUrl;
  final String? address;
  final String? bio;
  final bool emailVerified;
  final bool phoneVerified;
  final bool isDesigner; // Based on 'position' field from API
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserModelEnhanced({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.apiToken,
    this.deviceToken,
    this.photoUrl,
    this.address,
    this.bio,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.isDesigner = false,
    this.createdAt,
    this.lastLoginAt,
  });

  /// Create from Laravel API response
  factory UserModelEnhanced.fromJson(Map<String, dynamic> json) {
    // Parse position field to determine if user is designer
    bool designer = false;
    if (json['position'] != null) {
      designer = json['position'].toString() == 'true' ||
                 json['position'].toString() == '1' ||
                 json['position'] == true;
    }

    // Parse avatar/photo URL - handle Media object format
    String? photoUrl;
    if (json['avatar'] is Map) {
      // Media object with url, thumb, icon fields
      final avatar = json['avatar'] as Map;
      photoUrl = avatar['url'] ?? avatar['thumb'] ?? avatar['icon'];
    } else if (json['avatar'] is String) {
      photoUrl = json['avatar'];
    }
    // Fallback: Check media array
    if (photoUrl == null && json['media'] is List && (json['media'] as List).isNotEmpty) {
      final media = (json['media'] as List).first;
      if (media is Map) {
        photoUrl = media['url'] ?? media['thumb'] ?? media['icon'];
      }
    }

    // Fix old domain URLs (hawwcom.com -> hawacom.sa)
    if (photoUrl != null) {
      photoUrl = photoUrl.replaceAll('hawwcom.com', 'hawacom.sa');
      photoUrl = photoUrl.replaceAll('http://', 'https://');
    }

    // Parse address from custom_fields or direct field
    String? address;
    try {
      address = json['custom_fields']?['address']?['view'];
    } catch (e) {
      address = json['address'];
    }

    // Parse bio from custom_fields or direct field
    String? bio;
    try {
      bio = json['custom_fields']?['bio']?['view'];
    } catch (e) {
      bio = json['bio'];
    }

    return UserModelEnhanced(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      apiToken: json['api_token'],
      deviceToken: json['device_token'],
      photoUrl: photoUrl,
      address: address,
      bio: bio,
      emailVerified: json['email_verified_at'] != null,
      phoneVerified: json['phone_verified_at'] != null,
      isDesigner: designer,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      lastLoginAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  /// Create from Firebase User (for initial auth)
  factory UserModelEnhanced.fromFirebaseUser(dynamic firebaseUser) {
    return UserModelEnhanced(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified ?? false,
      createdAt: firebaseUser.metadata?.creationTime,
      lastLoginAt: firebaseUser.metadata?.lastSignInTime,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };

    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (apiToken != null) data['api_token'] = apiToken;
    if (deviceToken != null) data['device_token'] = deviceToken;
    if (address != null) data['address'] = address;
    if (bio != null) data['bio'] = bio;
    if (photoUrl != null) data['avatar'] = photoUrl;

    data['position'] = isDesigner;

    if (phoneVerified) {
      data['phone_verified_at'] = DateTime.now().toIso8601String();
    }

    return data;
  }

  /// Simplified JSON for local storage
  Map<String, dynamic> toStorageJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'apiToken': apiToken,
      'photoUrl': photoUrl,
      'address': address,
      'bio': bio,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'isDesigner': isDesigner,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Load from local storage JSON
  factory UserModelEnhanced.fromStorageJson(Map<String, dynamic> json) {
    return UserModelEnhanced(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      apiToken: json['apiToken'],
      photoUrl: json['photoUrl'],
      address: json['address'],
      bio: json['bio'],
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      isDesigner: json['isDesigner'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
    );
  }

  /// Copy with method
  UserModelEnhanced copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? apiToken,
    String? deviceToken,
    String? photoUrl,
    String? address,
    String? bio,
    bool? emailVerified,
    bool? phoneVerified,
    bool? isDesigner,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModelEnhanced(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      apiToken: apiToken ?? this.apiToken,
      deviceToken: deviceToken ?? this.deviceToken,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isDesigner: isDesigner ?? this.isDesigner,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Get display name or email
  String get displayNameOrEmail => name.isNotEmpty ? name : email;

  /// Check if user has complete profile
  bool get hasCompleteProfile {
    return name.isNotEmpty &&
           email.isNotEmpty &&
           phoneNumber != null &&
           phoneNumber!.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        apiToken,
        deviceToken,
        photoUrl,
        address,
        bio,
        emailVerified,
        phoneVerified,
        isDesigner,
        createdAt,
        lastLoginAt,
      ];
}
