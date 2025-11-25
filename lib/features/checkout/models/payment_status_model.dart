import '../../../core/models/base_model.dart';

/// Payment status model - Pending, Paid, Failed, etc.
class PaymentStatusModel extends BaseModel {
  final String id;
  final String status;
  final int order;

  const PaymentStatusModel({
    required this.id,
    required this.status,
    required this.order,
  });

  @override
  List<Object?> get props => [id, status, order];

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
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

  /// Check if payment is pending
  bool get isPending => status.toLowerCase().contains('pending') || order == 0;

  /// Check if payment is completed
  bool get isPaid => status.toLowerCase().contains('paid') || order == 1;

  /// Check if payment failed
  bool get isFailed => status.toLowerCase().contains('failed') || order == -1;
}
