import 'package:equatable/equatable.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';

class NurseEntity extends Equatable {
  final int id;
  final UserService? userData;
  final String? nurseId;
  final String? associationCard;
  final String? licence;
  final String? certificate;
  final double? distanceKM;
  final double? distanceM;
  final int? specialtyId;

  final List<ReviewModel>? reviewList;
  final List<String>? languageList;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;
  final List<ServicesModel>? servicesList;

  const NurseEntity({
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
  });

  @override
  List<Object?> get props => [id];

  /// return type text in ui
  String viewTypeText() =>
      "${userData?.userType.toString().toLowerCase() == "nurse" ? translate("nurse.nurse") : translate("nurse.assistant")} "
          .replaceAll("null", "");
}
