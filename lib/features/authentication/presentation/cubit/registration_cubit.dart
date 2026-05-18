import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class RegistrationState {
  final int? selectedSpecialtyId;
  final SpecialtyEntity? selectedSpecialty;
  final NurseEntity? nurse;
  final File? license;
  final File? certificate;
  final File? nurseID;
  final File? associationCard;
  final File? relatedJobId;
  final File? avatar;
  final List<String>? languageList;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;

  const RegistrationState({
    this.selectedSpecialtyId,
    this.selectedSpecialty,
    this.nurse,
    this.license,
    this.certificate,
    this.nurseID,
    this.associationCard,
    this.relatedJobId,
    this.avatar,
    this.languageList,
    this.educationList,
    this.publicationsList,
    this.coursesList,
  });

  RegistrationState copyWith({
    int? selectedSpecialtyId,
    SpecialtyEntity? selectedSpecialty,
    NurseEntity? nurse,
    File? license,
    File? certificate,
    File? nurseID,
    File? associationCard,
    File? relatedJobId,
    File? avatar,
    List<String>? languageList,
    List<String>? educationList,
    List<String>? publicationsList,
    List<String>? coursesList,
    // Explicit null-clear flags (needed when callers want to keep null)
    bool clearSpecialty = false,
  }) {
    return RegistrationState(
      selectedSpecialtyId: selectedSpecialtyId ?? this.selectedSpecialtyId,
      selectedSpecialty:
          clearSpecialty ? null : (selectedSpecialty ?? this.selectedSpecialty),
      nurse: nurse ?? this.nurse,
      license: license ?? this.license,
      certificate: certificate ?? this.certificate,
      nurseID: nurseID ?? this.nurseID,
      associationCard: associationCard ?? this.associationCard,
      relatedJobId: relatedJobId ?? this.relatedJobId,
      avatar: avatar ?? this.avatar,
      languageList: languageList ?? this.languageList,
      educationList: educationList ?? this.educationList,
      publicationsList: publicationsList ?? this.publicationsList,
      coursesList: coursesList ?? this.coursesList,
    );
  }

  bool get isInfoCompleted {
    return nurse != null &&
        languageList != null &&
        languageList!.isNotEmpty &&
        educationList != null &&
        educationList!.isNotEmpty &&
        publicationsList != null &&
        publicationsList!.isNotEmpty &&
        coursesList != null &&
        coursesList!.isNotEmpty;
  }
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(const RegistrationState());

  static RegistrationCubit get(BuildContext context) =>
      BlocProvider.of<RegistrationCubit>(context);

  // -- Specialty -----------------------------------------------------------
  void selectSpecialty({required int id, SpecialtyEntity? entity}) {
    emit(state.copyWith(
      selectedSpecialtyId: id,
      selectedSpecialty: entity,
    ));
  }

  // -- Nurse entity (basic profile) ----------------------------------------
  void updateNurse(NurseEntity nurse) {
    emit(state.copyWith(nurse: nurse));
  }

  // -- Files ----------------------------------------------------------------
  void updateLicense(File file) => emit(state.copyWith(license: file));
  void updateCertificate(File file) => emit(state.copyWith(certificate: file));
  void updateNurseID(File file) => emit(state.copyWith(nurseID: file));
  void updateAssociationCard(File file) =>
      emit(state.copyWith(associationCard: file));
  void updateRelatedJobId(File file) =>
      emit(state.copyWith(relatedJobId: file));
  void updateAvatar(File file) => emit(state.copyWith(avatar: file));

  // -- Professional lists --------------------------------------------------
  void updateLanguageList(List<String> list) =>
      emit(state.copyWith(languageList: List.from(list)));

  void updateEducationList(List<String> list) =>
      emit(state.copyWith(educationList: List.from(list)));

  void updatePublicationsList(List<String> list) =>
      emit(state.copyWith(publicationsList: List.from(list)));

  void updateCoursesList(List<String> list) =>
      emit(state.copyWith(coursesList: List.from(list)));

  // -- Reset ---------------------------------------------------------------
  void reset() {
    _deleteFileSafely(state.license);
    _deleteFileSafely(state.certificate);
    _deleteFileSafely(state.nurseID);
    _deleteFileSafely(state.associationCard);
    _deleteFileSafely(state.relatedJobId);
    _deleteFileSafely(state.avatar);

    emit(const RegistrationState());
  }

  void _deleteFileSafely(File? file) {
    try {
      if (file != null && file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      debugPrint("Failed to delete temp file: $e");
    }
  }
}
