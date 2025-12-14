import 'package:equatable/equatable.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';

class DoctorEntity extends Equatable {
  final int id;
  final UserService? userData;
  final String? doctorId;
  final String? associationCard;
  final String? licence;
  final String? certificate;
  final double? distanceKM;
  final double? distanceM;

  final List<ReviewModel>? reviewList;
  final List<String>? languageList;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;
  final List<ServicesModel>? servicesList;

  const DoctorEntity({
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
    this.servicesList,
    this.distanceKM,
    this.distanceM,
  });

  @override
  List<Object?> get props => [id];

  /// return type text in ui
  String viewTypeText() => "${translate("doctor.doctor")} ".replaceAll("null", "");
}
