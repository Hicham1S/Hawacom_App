import 'package:equatable/equatable.dart';
import '../../../features/services/models/media_model.dart';
import '../../../features/profile/models/address_model.dart';
import 'e_provider_type_model.dart';
import 'availability_hour_model.dart';

/// Model for E-Provider (Service Provider)
class EProviderModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<MediaModel> images;
  final String? phoneNumber;
  final String? mobileNumber;
  final EProviderTypeModel? type;
  final List<AvailabilityHourModel> availabilityHours;
  final double? availabilityRange;
  final bool available;
  final bool featured;
  final List<AddressModel> addresses;
  final double? rate;
  final int totalReviews;
  final bool verified;
  final int bookingsInProgress;

  const EProviderModel({
    required this.id,
    required this.name,
    required this.description,
    this.images = const [],
    this.phoneNumber,
    this.mobileNumber,
    this.type,
    this.availabilityHours = const [],
    this.availabilityRange,
    this.available = false,
    this.featured = false,
    this.addresses = const [],
    this.rate,
    this.totalReviews = 0,
    this.verified = false,
    this.bookingsInProgress = 0,
  });

  /// Create from JSON
  factory EProviderModel.fromJson(Map<String, dynamic> json) {
    // Extract multilingual strings
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

    // Parse images
    List<MediaModel> parseImages(dynamic field) {
      if (field == null) return [];
      if (field is List) {
        return field
            .map((item) => MediaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    // Parse availability hours
    List<AvailabilityHourModel> parseAvailabilityHours(dynamic field) {
      if (field == null) return [];
      if (field is List) {
        return field
            .map((item) =>
                AvailabilityHourModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    // Parse addresses
    List<AddressModel> parseAddresses(dynamic field) {
      if (field == null) return [];
      if (field is List) {
        return field
            .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return EProviderModel(
      id: json['id']?.toString() ?? '',
      name: extractString(json['name']),
      description: extractString(json['description']),
      images: parseImages(json['images']),
      phoneNumber: json['phone_number']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      type: json['e_provider_type'] != null
          ? EProviderTypeModel.fromJson(
              json['e_provider_type'] as Map<String, dynamic>)
          : null,
      availabilityHours: parseAvailabilityHours(json['availability_hours']),
      availabilityRange: json['availability_range'] != null
          ? double.tryParse(json['availability_range'].toString())
          : null,
      available: json['available'] == true || json['available'] == 1,
      featured: json['featured'] == true || json['featured'] == 1,
      addresses: parseAddresses(json['addresses']),
      rate: json['rate'] != null
          ? double.tryParse(json['rate'].toString())
          : null,
      totalReviews: json['total_reviews'] != null
          ? int.tryParse(json['total_reviews'].toString()) ?? 0
          : 0,
      verified: json['verified'] == true || json['verified'] == 1,
      bookingsInProgress: json['bookings_in_progress'] != null
          ? int.tryParse(json['bookings_in_progress'].toString()) ?? 0
          : 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images.map((e) => e.toJson()).toList(),
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (type != null) 'e_provider_type': type!.toJson(),
      'availability_hours':
          availabilityHours.map((e) => e.toJson()).toList(),
      if (availabilityRange != null) 'availability_range': availabilityRange,
      'available': available,
      'featured': featured,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      if (rate != null) 'rate': rate,
      'total_reviews': totalReviews,
      'verified': verified,
      'bookings_in_progress': bookingsInProgress,
    };
  }

  /// Get first image URL
  String get firstImageUrl =>
      images.isNotEmpty ? images.first.url : '';

  /// Get first image thumbnail
  String get firstImageThumb =>
      images.isNotEmpty ? images.first.thumb ?? images.first.url : '';

  /// Get first address
  String get firstAddress =>
      addresses.isNotEmpty ? addresses.first.address : '';

  /// Check if provider has data
  bool get hasData => id.isNotEmpty && name.isNotEmpty;

  /// Group availability hours by day
  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    for (var hour in availabilityHours) {
      if (result.containsKey(hour.day)) {
        result[hour.day]!.add('${hour.startAt} - ${hour.endAt}');
      } else {
        result[hour.day] = ['${hour.startAt} - ${hour.endAt}'];
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        phoneNumber,
        mobileNumber,
        type,
        availabilityHours,
        availabilityRange,
        available,
        featured,
        addresses,
        rate,
        totalReviews,
        verified,
        bookingsInProgress,
      ];
}
