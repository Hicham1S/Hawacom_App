import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

/// Repository for wallet-related API calls
class WalletRepository extends BaseRepository {
  WalletRepository({super.apiClient});

  /// Get user wallet
  Future<WalletModel?> getWallet() async {
    try {
      final response = await apiClient.get('wallets/my');

      if (response.success && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return WalletModel.fromJson(response.data as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting wallet: $e');
      return null;
    }
  }

  /// Get wallet transactions
  Future<List<WalletTransactionModel>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await apiClient.get(
        'wallet_transactions',
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => WalletTransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting wallet transactions: $e');
      return [];
    }
  }

  /// Add funds to wallet
  Future<bool> addFunds(double amount) async {
    try {
      final response = await apiClient.post(
        'wallets/credit',
        data: {'amount': amount},
      );

      return response.success;
    } catch (e) {
      debugPrint('Error adding funds: $e');
      return false;
    }
  }

  /// Deduct funds from wallet
  Future<bool> deductFunds(double amount, String description) async {
    try {
      final response = await apiClient.post(
        'wallets/debit',
        data: {
          'amount': amount,
          'description': description,
        },
      );

      return response.success;
    } catch (e) {
      debugPrint('Error deducting funds: $e');
      return false;
    }
  }

  /// Check if wallet has sufficient balance
  Future<bool> hasSufficientBalance(double amount) async {
    try {
      final wallet = await getWallet();
      if (wallet == null) return false;
      return wallet.balance >= amount;
    } catch (e) {
      debugPrint('Error checking balance: $e');
      return false;
    }
  }
}
