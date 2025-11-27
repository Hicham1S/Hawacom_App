import 'package:equatable/equatable.dart';

/// Model for E-Provider Type
class EProviderTypeModel extends Equatable {
  final String id;
  final String name;
  final double? commission;

  const EProviderTypeModel({
    required this.id,
    required this.name,
    this.commission,
  });

  /// Create from JSON
  factory EProviderTypeModel.fromJson(Map<String, dynamic> json) {
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

    return EProviderTypeModel(
      id: json['id']?.toString() ?? '',
      name: extractString(json['name']),
      commission: json['commission'] != null
          ? double.tryParse(json['commission'].toString())
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (commission != null) 'commission': commission,
    };
  }

  @override
  List<Object?> get props => [id, name, commission];
}
