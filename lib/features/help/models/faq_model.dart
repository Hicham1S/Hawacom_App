import 'package:equatable/equatable.dart';

/// Model for FAQ (Frequently Asked Question)
class FaqModel extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String? categoryId;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.categoryId,
  });

  /// Create from JSON
  factory FaqModel.fromJson(Map<String, dynamic> json) {
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

    return FaqModel(
      id: json['id']?.toString() ?? '',
      question: extractString(json['question']),
      answer: extractString(json['answer']),
      categoryId: json['faq_category_id']?.toString(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      if (categoryId != null) 'faq_category_id': categoryId,
    };
  }

  @override
  List<Object?> get props => [id, question, answer, categoryId];
}
