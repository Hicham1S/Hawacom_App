import '../../../core/models/base_model.dart';
import '../../services/models/service_model.dart';
import 'booking_status_model.dart';

/// Represents a service booking/order
class BookingModel extends BaseModel {
  final String id;
  final String? hint;
  final bool cancel;
  final double duration;
  final int quantity;
  final BookingStatusModel status;
  final ServiceModel service;

  final DateTime bookingAt;
  final DateTime? startAt;
  final DateTime? endsAt;
  final double? taxesValue;
  final double? couponDiscount;
  final String? paymentId;
  final String? paymentStatus;
  final String? paymentMethod;

  const BookingModel({
    required this.id,
    this.hint,
    this.cancel = false,
    this.duration = 0.0,
    this.quantity = 1,
    required this.status,
    required this.service,

    required this.bookingAt,
    this.startAt,
    this.endsAt,
    this.taxesValue,
    this.couponDiscount,
    this.paymentId,
    this.paymentStatus,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        hint,
        cancel,
        duration,
        quantity,
        status,
        service,

        bookingAt,
        startAt,
        endsAt,
        taxesValue,
        couponDiscount,
        paymentId,
        paymentStatus,
        paymentMethod,
      ];

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      hint: json['hint']?.toString(),
      cancel: json['cancel'] == true || json['cancel'] == 1,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      status: json['booking_status'] != null
          ? BookingStatusModel.fromJson(json['booking_status'])
          : BookingStatusModel(id: '0', status: 'Unknown', order: 0),
      service: json['e_service'] != null
          ? ServiceModel.fromJson(json['e_service'])
          : ServiceModel(
              id: '0',
              name: 'Unknown Service',
              media: [],
              price: 0.0,
              rate: 0.0,
              totalReviews: 0,
              featured: false,
              isFavorite: false,
              categories: [],
            ),

      bookingAt: json['booking_at'] != null
          ? DateTime.parse(json['booking_at'])
          : DateTime.now(),
      startAt: json['start_at'] != null ? DateTime.parse(json['start_at']) : null,
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at']) : null,
      taxesValue: (json['taxes_value'] as num?)?.toDouble(),
      couponDiscount: (json['coupon_discount'] as num?)?.toDouble(),
      paymentId: json['payment']?['id']?.toString(),
      paymentStatus: json['payment']?['payment_status']?['status']?.toString(),
      paymentMethod: json['payment']?['payment_method']?['name']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (hint != null) 'hint': hint,
      'cancel': cancel,
      'duration': duration,
      'quantity': quantity,
      'booking_status_id': status.id,
      'e_service_id': service.id,
      
      // WORKAROUND: Backend expects full service object (backend bug)
      // TODO: Remove this when backend is fixed to use just e_service_id
      'e_service': service.toJson(),

      'booking_at': bookingAt.toUtc().toIso8601String(),
      if (startAt != null) 'start_at': startAt!.toUtc().toIso8601String(),
      if (endsAt != null) 'ends_at': endsAt!.toUtc().toIso8601String(),
      
      // Remote address - for services that don't require physical location
      'address': {
        'address': 'Remote Service',
        'latitude': 0.0,
        'longitude': 0.0,
      },
    };
  }

  /// Calculate the subtotal (price * quantity or price * duration)
  double getSubtotal() {
    if (service.priceUnit == 'fixed') {
      return service.actualPrice * (quantity >= 1 ? quantity : 1);
    } else {
      return service.actualPrice * duration;
    }
  }

  /// Get tax value
  double getTaxesValue() {
    return taxesValue ?? 0.0;
  }

  /// Get coupon discount value (negative)
  double getCouponValue() {
    return -(couponDiscount ?? 0.0);
  }

  /// Calculate the total price
  double getTotal() {
    return getSubtotal() + getTaxesValue() + getCouponValue();
  }
}
