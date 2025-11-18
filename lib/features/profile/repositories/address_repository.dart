import '../../../core/repositories/base_repository.dart';
import '../../../core/config/api_config.dart';
import '../models/address_model.dart';

/// Repository for address management API calls
class AddressRepository extends BaseRepository {
  AddressRepository({super.apiClient});

  /// Get all addresses for current user
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await apiClient.get(ApiConfig.addresses);

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => AddressModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get address by ID
  Future<AddressModel?> getAddressById(String id) async {
    try {
      final response = await apiClient.get('${ApiConfig.addresses}/$id');

      if (response.success && response.data is Map) {
        return AddressModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Create new address
  Future<AddressModel?> createAddress(AddressModel address) async {
    try {
      final response = await apiClient.post(
        ApiConfig.addresses,
        data: address.toJson(),
      );

      if (response.success && response.data is Map) {
        return AddressModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing address
  Future<AddressModel?> updateAddress(String id, AddressModel address) async {
    try {
      final response = await apiClient.put(
        '${ApiConfig.addresses}/$id',
        data: address.toJson(),
      );

      if (response.success && response.data is Map) {
        return AddressModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(String id) async {
    try {
      final response = await apiClient.delete('${ApiConfig.addresses}/$id');
      return response.success;
    } catch (e) {
      rethrow;
    }
  }

  /// Set address as default
  Future<bool> setDefaultAddress(String id) async {
    try {
      final response = await apiClient.put(
        '${ApiConfig.addresses}/$id',
        data: {'default': true},
      );
      return response.success;
    } catch (e) {
      rethrow;
    }
  }
}
