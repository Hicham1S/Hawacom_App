/// Address model for user addresses
class AddressModel {
  final String id;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final String? userId;

  AddressModel({
    required this.id,
    required this.description,
    required this.address,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.userId,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      isDefault: json['default'] == true || json['default'] == 1,
      userId: json['user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'default': isDefault,
      if (userId != null) 'user_id': userId,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Check if address has valid coordinates
  bool hasCoordinates() {
    return latitude != null && longitude != null;
  }

  /// Get short description for display
  String get displayDescription {
    if (description.isNotEmpty) return description;
    if (address.length > 30) {
      return '${address.substring(0, 30)}...';
    }
    return address;
  }

  /// Copy with method for updating fields
  AddressModel copyWith({
    String? id,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? userId,
  }) {
    return AddressModel(
      id: id ?? this.id,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      userId: userId ?? this.userId,
    );
  }
}
