import 'package:icare/features/search/domain/entities/searchable_entity.dart';

/// Base interface for all searchable models (NurseModel, DoctorModel, etc.)
/// This enables generic parsing and data transformation
abstract class SearchableModel {
  /// Convert model to entity
  SearchableEntity toEntity();

  /// Get the provider type identifier (e.g., "doctor", "nurse")
  String get providerType;

  /// Factory method to create model from JSON based on provider type
  /// This will be implemented by concrete model classes
  static SearchableModel fromJson(
      Map<String, dynamic> json, String providerType) {
    throw UnimplementedError(
      'fromJson must be implemented by concrete model classes',
    );
  }
}
