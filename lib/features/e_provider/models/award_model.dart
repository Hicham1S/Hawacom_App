import 'package:equatable/equatable.dart';

/// Model for Provider Award
class AwardModel extends Equatable {
  final String id;
  final String title;
  final String description;

  const AwardModel({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Create from JSON
  factory AwardModel.fromJson(Map<String, dynamic> json) {
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

    return AwardModel(
      id: json['id']?.toString() ?? '',
      title: extractString(json['title']),
      description: extractString(json['description']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, title, description];
}
