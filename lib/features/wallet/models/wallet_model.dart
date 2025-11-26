/// Wallet model for user wallet balance
class WalletModel {
  final String id;
  final String name;
  final double balance;
  final String? currency;
  final bool isEnabled;

  const WalletModel({
    required this.id,
    required this.name,
    required this.balance,
    this.currency = 'SAR',
    this.isEnabled = true,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      balance: _parseDouble(json['balance']) ?? 0.0,
      currency: json['currency']?.toString() ?? 'SAR',
      isEnabled: json['enabled'] == true || json['enabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'enabled': isEnabled,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Get formatted balance with currency
  String get formattedBalance {
    return '${balance.toStringAsFixed(2)} $currency';
  }

  /// Get short wallet name (last 16 characters)
  String get shortName {
    if (name.length <= 16) return name;
    return name.substring(name.length - 16);
  }

  /// Copy with method
  WalletModel copyWith({
    String? id,
    String? name,
    double? balance,
    String? currency,
    bool? isEnabled,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
