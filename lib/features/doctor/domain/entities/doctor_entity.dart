import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

class DoctorEntity extends SearchableEntity {
  @override
  final int id;
  @override
  final UserService? userData;
  final String? doctorId;
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
  DoctorEntity({
    required this.id,
    required this.userData,
    this.doctorId,
    this.associationCard,
    this.licence,
    this.certificate,
    this.reviewList,
    this.languageList,
    this.educationList,
    this.publicationsList,
    this.coursesList,
    this.distanceKM,
    this.distanceM,
    this.specialtyId,
    this.verificationStatus,
  });

  @override
  List<Object?> get props => [id];

  @override
  String get providerType => 'doctor';

  /// return type text in ui
  @override
  String viewTypeText() =>
      "${translate("doctor.doctor")} ".replaceAll("null", "");

  @override
  List<ServicesModel>? get servicesList => null;
}
