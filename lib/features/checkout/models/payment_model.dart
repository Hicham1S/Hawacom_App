import '../../../core/models/base_model.dart';
import 'payment_method_model.dart';
import 'payment_status_model.dart';

/// Payment model - Complete payment information for a booking
class PaymentModel extends BaseModel {
  final String? id;
  final double? amount;
  final String? description;
  final PaymentMethodModel? paymentMethod;
  final PaymentStatusModel? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PaymentModel({
    this.id,
    this.amount,
    this.description,
    this.paymentMethod,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        paymentMethod,
        paymentStatus,
        createdAt,
        updatedAt,
      ];

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString(),
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      description: json['description']?.toString(),
      paymentMethod: json['payment_method'] != null
          ? PaymentMethodModel.fromJson(json['payment_method'])
          : null,
      paymentStatus: json['payment_status'] != null
          ? PaymentStatusModel.fromJson(json['payment_status'])
          : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'payment_method': paymentMethod?.toJson(),
      'payment_status': paymentStatus?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if payment is completed
  bool get isPaid => paymentStatus?.isPaid ?? false;

  /// Check if payment is pending
  bool get isPending => paymentStatus?.isPending ?? true;

  /// Check if payment failed
  bool get isFailed => paymentStatus?.isFailed ?? false;
}
