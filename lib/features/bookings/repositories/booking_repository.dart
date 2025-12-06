import '../../../core/api/api_endpoints.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/services/session_manager.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';

/// Repository for managing booking/order data from the API
class BookingRepository extends BaseRepository {
  final SessionManager _sessionManager;

  BookingRepository({super.apiClient, SessionManager? sessionManager})
      : _sessionManager = sessionManager ?? SessionManager();
  /// Get all bookings for the current user with optional status filter
  ///
  /// [statusId] - Filter by booking status ID
  /// [page] - Page number for pagination (default: 1)
  /// [limit] - Number of items per page (default: 10)
  Future<List<BookingModel>> getAllBookings({
    String? statusId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'with': 'bookingStatus;payment;payment.paymentStatus',
        'orderBy': 'created_at',
        'sortedBy': 'desc',
        'limit': limit.toString(),
        'offset': ((page - 1) * limit).toString(),
      };

      if (statusId != null && statusId.isNotEmpty) {
        queryParams['search'] = 'booking_status_id:$statusId';
      }

      final response = await apiClient.get(
        ApiEndpoints.bookings,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  /// Get a single booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.bookingById(bookingId),
        queryParameters: {
          'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
        },
      );

      if (response.data['success'] == true) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load booking');
      }
    } catch (e) {
      throw Exception('Failed to load booking: $e');
    }
  }

  /// Get all available booking statuses
  Future<List<BookingStatusModel>> getBookingStatuses() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.bookingStatuses,
        queryParameters: {
          'only': 'id;status;order',
          'orderBy': 'order',
          'sortedBy': 'asc',
        },
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => BookingStatusModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load booking statuses');
      }
    } catch (e) {
      throw Exception('Failed to load booking statuses: $e');
    }
  }

  /// Create a new booking
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      // Get current user ID for the address
      final user = await _sessionManager.getUser();
      final userId = user?['id']?.toString();

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Get booking data and add user_id to address
      final bookingData = booking.toJson();
      
      // Add user_id to the address object
      if (bookingData['address'] is Map) {
        bookingData['address']['user_id'] = userId;
      }

      final response = await apiClient.post(
        ApiEndpoints.bookings,
        data: bookingData,
      );

      if (response.data['success'] == true) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create booking');
      }
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Update an existing booking (e.g., cancel)
  Future<BookingModel> updateBooking(BookingModel booking) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.bookingById(booking.id),
        data: booking.toJson(),
      );

      if (response.data['success'] == true) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update booking');
      }
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.bookingById(bookingId),
        data: {'cancel': true},
      );

      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
