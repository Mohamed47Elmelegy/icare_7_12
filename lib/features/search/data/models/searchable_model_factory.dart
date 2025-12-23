import 'package:icare/features/doctor/data/models/doctor_model.dart';
import 'package:icare/features/nurse/data/models/nurse_model.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

/// Factory for creating searchable models from JSON based on provider type
class SearchableModelFactory {
  /// Create a searchable entity from JSON based on provider type
  static SearchableEntity fromJson(
    Map<String, dynamic> json,
    String providerType,
  ) {
    switch (providerType.toLowerCase()) {
      case 'doctor':
        return DoctorModel.fromJson(json);
      case 'nurse':
      case 'assistant':
        return NurseModel.fromJson(json);
      default:
        throw UnsupportedError(
          'Unsupported provider type: $providerType. '
          'Supported types are: doctor, nurse, assistant',
        );
    }
  }

  /// Parse a list of JSON objects to searchable entities
  static List<SearchableEntity> fromJsonList(
    List<dynamic> jsonList,
    String providerType,
  ) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>, providerType))
        .toList();
  }
}
