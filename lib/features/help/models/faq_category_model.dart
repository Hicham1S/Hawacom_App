import 'package:equatable/equatable.dart';

/// Model for FAQ Category
class FaqCategoryModel extends Equatable {
  final String id;
  final String name;

  const FaqCategoryModel({
    required this.id,
    required this.name,
  });

  /// Create from JSON
  factory FaqCategoryModel.fromJson(Map<String, dynamic> json) {
    // Extract multilingual strings
    String extractString(dynamic field, [String defaultValue = '']) {
      if (field == null) return defaultValue;
      if (field is String) return field;
      if (field is Map) {
        return field['ar']?.toString() ??
            field['en']?.toString() ??
            field.values.firstWhere((v) => v != null, orElse: () => defaultValue)?.toString() ??
            defaultValue;
      }
      return field.toString();
    }

    return FaqCategoryModel(
      id: json['id']?.toString() ?? '',
      name: extractString(json['name']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
