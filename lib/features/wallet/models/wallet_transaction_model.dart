/// Transaction action type
enum TransactionAction {
  credit,
  debit;

  String get displayName {
    switch (this) {
      case TransactionAction.credit:
        return 'إيداع';
      case TransactionAction.debit:
        return 'سحب';
    }
  }
}

/// Wallet transaction model
class WalletTransactionModel {
  final String id;
  final double amount;
  final String description;
  final TransactionAction action;
  final DateTime createdAt;
  final String? userId;
  final String? userName;

  const WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.action,
    required this.createdAt,
    this.userId,
    this.userName,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      amount: _parseDouble(json['amount']) ?? 0.0,
      description: json['description']?.toString() ?? '',
      action: _parseAction(json['action']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      userId: json['user_id']?.toString(),
      userName: json['user']?['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'action': action.name,
      'created_at': createdAt.toIso8601String(),
      if (userId != null) 'user_id': userId,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static TransactionAction _parseAction(dynamic value) {
    if (value == null) return TransactionAction.debit;
    final str = value.toString().toLowerCase();
    if (str == 'credit') return TransactionAction.credit;
    return TransactionAction.debit;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Get formatted amount with sign
  String get formattedAmount {
    final sign = action == TransactionAction.credit ? '+' : '-';
    return '$sign${amount.toStringAsFixed(2)} ر.س';
  }

  /// Get short description (max 20 characters)
  String get shortDescription {
    if (description.length <= 20) return description;
    return description.substring(description.length - 20);
  }

  /// Check if transaction is a credit
  bool get isCredit => action == TransactionAction.credit;

  /// Check if transaction is a debit
  bool get isDebit => action == TransactionAction.debit;
}
