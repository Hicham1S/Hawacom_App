import '../../../core/models/base_model.dart';

/// Represents the status of a booking (e.g., Pending, Accepted, In Progress, Done, Failed)
class BookingStatusModel extends BaseModel {
  final String id;
  final String status;
  final int order;

  const BookingStatusModel({
    required this.id,
    required this.status,
    required this.order,
  });

  @override
  List<Object?> get props => [id, status, order];

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'order': order,
    };
  }
}
