import 'package:equatable/equatable.dart';

/// Model for Availability Hour
class AvailabilityHourModel extends Equatable {
  final String id;
  final String day;
  final String startAt;
  final String endAt;
  final String? data;

  const AvailabilityHourModel({
    required this.id,
    required this.day,
    required this.startAt,
    required this.endAt,
    this.data,
  });

  /// Create from JSON
  factory AvailabilityHourModel.fromJson(Map<String, dynamic> json) {
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

    return AvailabilityHourModel(
      id: json['id']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      startAt: json['start_at']?.toString() ?? '',
      endAt: json['end_at']?.toString() ?? '',
      data: extractString(json['data']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'start_at': startAt,
      'end_at': endAt,
      if (data != null) 'data': data,
    };
  }

  @override
  List<Object?> get props => [id, day, startAt, endAt, data];
}
