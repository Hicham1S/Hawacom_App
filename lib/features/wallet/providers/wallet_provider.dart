import 'package:flutter/material.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../repositories/wallet_repository.dart';

/// Provider for managing wallet state
class WalletProvider extends ChangeNotifier {
  final WalletRepository _walletRepository = WalletRepository();

  // State
  WalletModel? _wallet;
  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = false;
  bool _isLoadingTransactions = false;
  String? _errorMessage;

  // Getters
  WalletModel? get wallet => _wallet;
  List<WalletTransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get errorMessage => _errorMessage;
  bool get hasWallet => _wallet != null;
  double get balance => _wallet?.balance ?? 0.0;

  /// Load wallet data
  Future<void> loadWallet() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _walletRepository.getWallet();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل المحفظة: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load wallet transactions
  Future<void> loadTransactions({int limit = 50}) async {
    _isLoadingTransactions = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _walletRepository.getTransactions(limit: limit);
      _isLoadingTransactions = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل المعاملات: $e';
      _isLoadingTransactions = false;
      notifyListeners();
    }
  }

  /// Add funds to wallet
  Future<bool> addFunds(double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _walletRepository.addFunds(amount);
      if (success) {
        await loadWallet();
        await loadTransactions();
      } else {
        _errorMessage = 'فشل إضافة الرصيد';
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'فشل إضافة الرصيد: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Check if wallet has sufficient balance
  Future<bool> hasSufficientBalance(double amount) async {
    if (_wallet == null) {
      await loadWallet();
    }
    return _wallet != null && _wallet!.balance >= amount;
  }

  /// Refresh wallet and transactions
  Future<void> refresh() async {
    await Future.wait([
      loadWallet(),
      loadTransactions(),
    ]);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
