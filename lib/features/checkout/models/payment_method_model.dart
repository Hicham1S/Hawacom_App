import '../../services/models/media_model.dart';
import '../../../core/models/base_model.dart';

/// Payment method model - Stripe, PayPal, Wallet, etc.
class PaymentMethodModel extends BaseModel {
  final String id;
  final String name;
  final String description;
  final MediaModel? logo;
  final String? route;
  final int order;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    this.route,
    required this.order,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, description, logo, route, order, isDefault];

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      logo: json['logo'] != null ? MediaModel.fromJson(json['logo']) : null,
      route: json['route']?.toString(),
      order: json['order'] as int? ?? 0,
      isDefault: json['default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo?.toJson(),
      'route': route,
      'order': order,
      'default': isDefault,
    };
  }

  /// Get short name (last 10 characters)
  String getShortName() {
    if (name.isEmpty) return 'Not Paid';
    return name.length > 10 ? name.substring(name.length - 10) : name;
  }

  /// Check if this is a wallet payment method
  bool get isWallet => route?.toLowerCase().contains('wallet') ?? false;

  /// Check if this is a cash payment method
  bool get isCash => route?.toLowerCase().contains('cash') ?? false;
}
