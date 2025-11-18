import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../repositories/address_repository.dart';

/// Provider for address state management
class AddressProvider extends ChangeNotifier {
  final AddressRepository _repository;

  AddressProvider({AddressRepository? repository})
      : _repository = repository ?? AddressRepository();

  // State
  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasAddresses => _addresses.isNotEmpty;

  /// Get default address
  AddressModel? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  /// Load all addresses
  Future<void> loadAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _addresses = await _repository.getAddresses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load addresses: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Create new address
  Future<bool> createAddress(AddressModel address) async {
    try {
      final newAddress = await _repository.createAddress(address);
      if (newAddress != null) {
        _addresses.add(newAddress);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to create address: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Update existing address
  Future<bool> updateAddress(String id, AddressModel address) async {
    try {
      final updatedAddress = await _repository.updateAddress(id, address);
      if (updatedAddress != null) {
        final index = _addresses.indexWhere((addr) => addr.id == id);
        if (index != -1) {
          _addresses[index] = updatedAddress;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update address: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(String id) async {
    try {
      final success = await _repository.deleteAddress(id);
      if (success) {
        _addresses.removeWhere((addr) => addr.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete address: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Set address as default
  Future<bool> setDefaultAddress(String id) async {
    try {
      final success = await _repository.setDefaultAddress(id);
      if (success) {
        // Update local state - set all to false, then set selected to true
        _addresses = _addresses.map((addr) {
          return addr.copyWith(isDefault: addr.id == id);
        }).toList();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to set default address: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Refresh addresses
  Future<void> refresh() async {
    await loadAddresses();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
