import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

class NurseEntity extends SearchableEntity {
  @override
  final int id;
  @override
  final UserService? userData;
  final String? nurseId;
  final String? associationCard;
  final String? licence;
  final String? certificate;
  @override
  final double? distanceKM;
  @override
  final double? distanceM;
  @override
  final String? specialtyId;
  @override
  final int? verificationStatus;
  final String? type;
  final int? userId; // Add this field

  @override
  final List<ReviewModel>? reviewList;
  @override
  final List<String>? languageList;
  @override
  final List<String>? educationList;
  @override
  final List<String>? publicationsList;
  @override
  final List<String>? coursesList;
  @override
  final List<ServicesModel>? servicesList;

  NurseEntity({
    required this.id,
    required this.userData,
    this.nurseId,
    this.associationCard,
    this.licence,
    this.certificate,
    this.reviewList,
    this.languageList,
    this.educationList,
    this.publicationsList,
    this.coursesList,
    this.servicesList,
    this.distanceKM,
    this.distanceM,
    this.specialtyId,
    this.verificationStatus,
    this.type,
    this.userId,
  });

  /// Create a copy of this entity with updated fields
  NurseEntity copyWith({
    int? id,
    UserService? userData,
    String? nurseId,
    String? associationCard,
    String? licence,
    String? certificate,
    List<ReviewModel>? reviewList,
    List<String>? languageList,
    List<String>? educationList,
    List<String>? publicationsList,
    List<String>? coursesList,
    List<ServicesModel>? servicesList,
    double? distanceKM,
    double? distanceM,
    String? specialtyId,
    int? verificationStatus,
    String? type,
    int? userId,
  }) {
    return NurseEntity(
      id: id ?? this.id,
      userData: userData ?? this.userData,
      nurseId: nurseId ?? this.nurseId,
      associationCard: associationCard ?? this.associationCard,
      licence: licence ?? this.licence,
      certificate: certificate ?? this.certificate,
      reviewList: reviewList ?? this.reviewList,
      languageList: languageList ?? this.languageList,
      educationList: educationList ?? this.educationList,
      publicationsList: publicationsList ?? this.publicationsList,
      coursesList: coursesList ?? this.coursesList,
      servicesList: servicesList ?? this.servicesList,
      distanceKM: distanceKM ?? this.distanceKM,
      distanceM: distanceM ?? this.distanceM,
      specialtyId: specialtyId ?? this.specialtyId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String get providerType => 'nurse';

  /// return type text in ui
  @override
  String viewTypeText() =>
      "${userData?.userType.toString().toLowerCase() == "nurse" ? translate("nurse.nurse") : translate("nurse.assistant")} "
          .replaceAll("null", "");
}
