import 'package:equatable/equatable.dart';

/// Base model class that all models extend
/// Provides common functionality for JSON serialization
abstract class BaseModel extends Equatable {
  const BaseModel();

  /// Convert model to JSON for API requests
  Map<String, dynamic> toJson();

  /// Convert model to JSON for local storage
  Map<String, dynamic> toStorageJson() => toJson();

  @override
  bool get stringify => true;
}
