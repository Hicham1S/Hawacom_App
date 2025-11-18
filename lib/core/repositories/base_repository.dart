import '../api/api_client.dart';

/// Base repository class that all repositories extend
/// Provides common API client access
abstract class BaseRepository {
  final ApiClient apiClient;

  BaseRepository({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();
}
