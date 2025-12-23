import 'package:equatable/equatable.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';

/// Base interface for all searchable entities (Nurse, Doctor, etc.)
/// This enables generic search functionality across different provider types
abstract class SearchableEntity extends Equatable {
  int get id;
  UserService? get userData;
  double? get distanceKM;
  double? get distanceM;
  String? get specialtyId;
  int? get verificationStatus;
  List<ReviewModel>? get reviewList;
  List<String>? get languageList;
  List<String>? get educationList;
  List<String>? get publicationsList;
  List<String>? get coursesList;
  List<ServicesModel>? get servicesList;

  /// Return type text for UI display (e.g., "Doctor", "Nurse")
  String viewTypeText();

  /// Get the provider type identifier (e.g., "doctor", "nurse")
  String get providerType;

  @override
  List<Object?> get props => [id];
}
