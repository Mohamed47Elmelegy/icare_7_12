import 'dart:io';
import 'package:icare/core/network/token_storage_helper.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/domain/use_cases/get_all_users_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_nurse_options_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_doctor_options_usecase.dart';
import 'package:icare/core/services/service_to_api_converter.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/account/domain/use_cases/delete_account_usecase.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';
import 'package:icare/features/account/domain/usecases/create_medical_report_usecase.dart';
import 'package:icare/features/account/domain/usecases/get_patient_medical_reports_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/domain/use_cases/change_password_usercase.dart';
import 'package:icare/features/account/domain/use_cases/get_user_service_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_user_usecase.dart';
import 'package:icare/features/account/domain/use_cases/get_user_full_data_usecase.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  bool showPassword = false;
  static AccountBloc get(BuildContext context) => BlocProvider.of(context);
  int? currentModifyService;
  int profileTapIndex = 0;
  bool enableUpdate = false;
  bool enableUpdateImg = false;

  final GetUserServiceUseCase getUserServiceUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final UpdateUserServiceUseCase updateUserServiceUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final UpdateProfileStatusUseCase updateProfileStatusUseCase;
  final GetUserFullDataUseCase getUserFullDataUseCase;
  final CreateMedicalReportUseCase createMedicalReportUseCase;
  final GetPatientMedicalReportsUseCase getPatientMedicalReportsUseCase;
  final UpdateNurseOptionsUseCase updateNurseOptionsUseCase;
  final UpdateDoctorOptionsUseCase updateDoctorOptionsUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  AccountBloc({
    required this.getUserServiceUseCase,
    required this.updateUserServiceUseCase,
    required this.changePasswordUseCase,
    required this.getAllUsersUseCase,
    required this.updateProfileStatusUseCase,
    required this.getUserFullDataUseCase,
    required this.createMedicalReportUseCase,
    required this.getPatientMedicalReportsUseCase,
    required this.updateNurseOptionsUseCase,
    required this.updateDoctorOptionsUseCase,
    required this.deleteAccountUseCase,
  }) : super(AccountInitialState()) {
    on<UpdateProfileEvent>((event, emit) async {
      await updateProfile(event, emit);
    });

    on<UpdateProfileCurrentDataEvent>((event, emit) {
      updateCurrentUserData(event, emit);
    });

    on<EnableUpdateProfileEvent>((event, emit) {
      enableUpdateProfile(event, emit);
    });

    on<FetchProfileDataEvent>((event, emit) async {
      await getProfileData(event, emit);
    });

    on<FetchAllUsersDataEvent>((event, emit) async {
      await getAllUsersData(event, emit);
    });

    on<ChangeUserPasswordEvent>((event, emit) async {
      await changeUserPassword(event, emit);
    });

    on<ChangeNotificationModeEvent>((event, emit) {
      changeNotificationMode(event, emit);
    });

    on<SwitchProfileTapsEvent>((event, emit) {
      switchProfileTaps(event, emit);
    });

    on<UpdateUserPatientDataEvent>((event, emit) {
      updateCurrentPatientData(event, emit);
    });

    on<UpdateNurseDataEvent>((event, emit) async {
      await updateNurseData(event, emit);
    });

    on<UpdateDoctorDataEvent>((event, emit) async {
      await updateDoctorData(event, emit);
    });

    on<SwitchProfileStatusEvent>((event, emit) async {
      await changeNurseProfileStatus(event, emit);
    });

    on<CreateMedicalReportEvent>((event, emit) async {
      await createMedicalReport(event, emit);
    });

    on<FetchPatientMedicalReportsEvent>((event, emit) async {
      await fetchPatientMedicalReports(event, emit);
    });

    on<DeleteAccountEvent>((event, emit) async {
      await deleteAccount(event, emit);
    });

    on<ModifyCurrentService>((event, emit) async {
      await modifyCurrentService(event, emit);
    });

    on<EnableModifyCurrentService>((event, emit) {
      enableModifyCurrentService(event, emit);
    });
  }

  enableUpdateProfile(EnableUpdateProfileEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.isImg == true) {
      enableUpdateImg = !enableUpdateImg;
    } else if (event.isSave == true) {
      enableUpdate = false;
      enableUpdateImg = false;
    } else {
      enableUpdate = !enableUpdate;
    }
    emit(const ProfileSuccessState());
  }

  int currentProfileTapsIndex = 0;
  switchProfileTaps(SwitchProfileTapsEvent event, emit) {
    emit(const ProfileLoadingState());
    currentProfileTapsIndex = event.index;
    emit(const ProfileSuccessState());
  }

  File? license;
  File? certificate;
  File? nurseID;
  File? doctorID;
  File? associationCard;
  File? relatedJobId;
  File? nurseAvatar;
  NurseEntity? nurse;
  DoctorEntity? doctor;
  List<String>? languageList;
  List<String>? educationList;
  List<String>? publicationsList;
  List<String>? coursesList;
  List<String>? emergencyContactsList;
  List<ServicesModel>? servicesList;
  SpecialtyEntity? selectedSpecialty;
  String currentPublication = "";
  String currentMedicalConditions = "";

  Future<void> updateNurseData(
      UpdateNurseDataEvent event, Emitter<AccountState> emit) async {
    if (state is ProfileLoadingState) return;
    try {
      emit(const ProfileLoadingState());
      if (event.nurse != null) nurse = event.nurse;
      if (event.license != null) license = event.license;
      if (event.certificate != null) certificate = event.certificate;
      if (event.nurseID != null) nurseID = event.nurseID;
      if (event.associationCard != null) {
        associationCard = event.associationCard;
      }
      if (event.relatedJobId != null) relatedJobId = event.relatedJobId;
      if (event.avatar != null) nurseAvatar = event.avatar;
      if (event.languageList != null) languageList = event.languageList;
      if (event.educationList != null) educationList = event.educationList;
      if (event.publicationsList != null) {
        publicationsList = event.publicationsList;
      }
      if (event.coursesList != null) coursesList = event.coursesList;
      if (event.emergencyContactsList != null) {
        emergencyContactsList = event.emergencyContactsList;
      }
      if (event.servicesList != null) servicesList = event.servicesList;

      final result = await updateNurseOptionsUseCase(options: {
        if (languageList != null) 'languages': languageList,
        if (educationList != null) 'education': educationList,
        if (publicationsList != null) 'publications': publicationsList,
        if (coursesList != null) 'courses': coursesList,
        if (emergencyContactsList != null)
          'emergency_contacts': emergencyContactsList,
        if (servicesList != null)
          'services':
              ServiceToApiConverter.convertServicesToPayload(servicesList!),
      });

      result.fold(
        (failure) => emit(const ProfileFailedState()),
        (success) {
          _afterUpdateProfile();
          emit(const UpdateNurseDataSuccessState());
        },
      );
    } catch (e) {
      emit(const ProfileFailedState());
    }
  }

  Future<void> updateDoctorData(
      UpdateDoctorDataEvent event, Emitter<AccountState> emit) async {
    if (state is ProfileLoadingState) return;
    try {
      emit(const ProfileLoadingState());
      if (event.doctor != null) doctor = event.doctor;
      if (event.license != null) license = event.license;
      if (event.certificate != null) certificate = event.certificate;
      if (event.doctorID != null) doctorID = event.doctorID;
      if (event.associationCard != null) {
        associationCard = event.associationCard;
      }
      if (event.relatedJobId != null) relatedJobId = event.relatedJobId;
      if (event.avatar != null) nurseAvatar = event.avatar;
      if (event.languageList != null) languageList = event.languageList;
      if (event.educationList != null) educationList = event.educationList;
      if (event.publicationsList != null) {
        publicationsList = event.publicationsList;
      }
      if (event.coursesList != null) coursesList = event.coursesList;
      if (event.emergencyContactsList != null) {
        emergencyContactsList = event.emergencyContactsList;
      }
      if (event.selectedSpecialty != null) {
        selectedSpecialty = event.selectedSpecialty;
      }

      final result = await updateDoctorOptionsUseCase(options: {
        if (languageList != null) 'languages': languageList,
        if (educationList != null) 'education': educationList,
        if (publicationsList != null) 'publications': publicationsList,
        if (coursesList != null) 'courses': coursesList,
        if (emergencyContactsList != null)
          'emergency_contacts': emergencyContactsList,
        if (selectedSpecialty != null) 'specialties_id': selectedSpecialty!.id,
      });

      result.fold(
        (failure) => emit(const ProfileFailedState()),
        (success) {
          _afterUpdateProfile();
          emit(const UpdateDoctorDataSuccessState());
        },
      );
    } catch (e) {
      emit(const ProfileFailedState());
    }
  }

  changeUserPassword(ChangeUserPasswordEvent event, emit) async {
    emit(ChangeUserPasswordState(response: AuthResponse(isLoad: true)));
    try {
      var res = await changePasswordUseCase(data: event.data);
      res.fold((l) {
        emit(ChangeUserPasswordState(
            response: AuthResponse(isFailed: true, msg: l.toString())));
      }, (data) async {
        if (data.isSuccess == true) {
          emit(ChangeUserPasswordState(
              response: AuthResponse(isSuccess: true, msg: data.msg)));
        } else {
          emit(ChangeUserPasswordState(
              response: AuthResponse(isFailed: true, msg: data.msg)));
        }
      });
    } catch (e) {
      emit(ChangeUserPasswordState(
          response: AuthResponse(isFailed: true, msg: e.toString())));
    }
  }

  UserService? currentUser;
  File? avatar;
  updateCurrentUserData(UpdateProfileCurrentDataEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.userData['avatar'] != null) avatar = event.userData['avatar'];
    emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
  }

  updateProfile(UpdateProfileEvent event, emit) async {
    if (state is UpdateProfileState &&
        (state as UpdateProfileState).response.isLoad == true) {
      return;
    }
    if (!Util.checkUser()) return;
    emit(UpdateProfileState(response: AuthResponse(isLoad: true)));
    try {
      var res = await updateUserServiceUseCase(userData: event.user);
      res.fold((l) {
        emit(UpdateProfileState(
            response: AuthResponse(isFailed: true, msg: l.toString())));
      }, (data) async {
        if (data.userId != 0) {
          // Trigger a silent refresh to get the full profile data (with relations)
          // after the update, while keeping the immediate success response.
          add(const FetchProfileDataEvent(isSilent: true));

          _afterUpdateProfile();
          emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
          await saveUserDate(AuthResponse(user: data));
        } else {
          emit(UpdateProfileState(
              response:
                  AuthResponse(isFailed: true, msg: translate("toast.wrong"))));
        }
      });
    } catch (e) {
      emit(UpdateProfileState(
          response: AuthResponse(isFailed: true, msg: e.toString())));
    }
  }

  _afterUpdateProfile() {
    enableUpdate = false;
    enableUpdateImg = false;
    currentPublication = "";
    currentMedicalConditions = "";
  }

  getProfileData(event, emit) async {
    // AccountBloc received FetchProfileDataEvent


    if (state is FetchProfileDataState &&
        (state as FetchProfileDataState).response.isLoad == true) {
      // Already loading, ignoring duplicate event

      return;
    }

    if (!Util.checkUser()) {
      // No user session found, aborting

      return;
    }

    if (!event.isSilent) {
      emit(FetchProfileDataState(response: AuthResponse(isLoad: true)));
      emit(FetchProfileDataState(response: AuthResponse(isLoad: true)));
      // Emitted FetchProfileDataState (Loading)

    }

    try {
      var res = event.userId != null
          ? await getUserFullDataUseCase(userId: event.userId!)
          : await getUserServiceUseCase();
      res.fold((l) {

        emit(FetchProfileDataState(
            response: AuthResponse(isFailed: true, msg: l.toString())));
      }, (data) async {
        // Successfully fetched profile


        if (data.userId != null && data.userId != 0) {
          currentUser = data;
          isOnline = currentUser!.status ?? false;
          emergencyContactsList = currentUser!.emergencyContactsList;

          if (currentUser!.nurse != null) {
            var nurse = currentUser!.nurse;
            languageList = nurse!.languageList;
            educationList = nurse.educationList;
            publicationsList = nurse.publicationsList;
            coursesList = nurse.coursesList;
            servicesList = nurse.servicesList;
            // Resolved Nurse data

          }

          if (currentUser!.doctor != null) {
            var doctor = currentUser!.doctor;
            languageList = doctor!.languageList;
            educationList = doctor.educationList;
            publicationsList = doctor.publicationsList;
            coursesList = doctor.coursesList;
            if (doctor.specialtyId != null) {
              selectedSpecialty = SpecialtyEntity(
                id: int.tryParse(doctor.specialtyId!) ?? 0,
                title: '',
              );
            }
            // Resolved Doctor data

          }

          _afterUpdateProfile();
          emit(FetchProfileDataState(
              response: AuthResponse(user: data, isSuccess: true)));
          emit(FetchProfileDataState(
              response: AuthResponse(user: data, isSuccess: true)));
          // Emitted FetchProfileDataState (Success)


          await saveUserDate(AuthResponse(user: data, isSuccess: true));
        } else {
          // Received empty or invalid userId

          emit(FetchProfileDataState(
              response:
                  AuthResponse(isFailed: true, msg: "Invalid user data")));
        }
      });
    } catch (e) {

      emit(FetchProfileDataState(
          response: AuthResponse(isFailed: true, msg: e.toString())));
    }
  }

  saveUserDate(AuthResponse res) async {
    if (res.user == null) return;
    if (res.user!.userId != null) {
      await SharedPref()
          .setPreferencesString(Constants.userId, res.user!.userId.toString());
    }
    if (res.user!.email != null && res.user!.email != "") {
      await SharedPref()
          .setPreferencesString(Constants.email, res.user!.email.toString());
    }
    if (res.user!.phoneNumber != null && res.user!.phoneNumber != "") {
      await SharedPref().setPreferencesString(
          Constants.mobile, res.user!.phoneNumber.toString());
    }
    if (res.user!.userName != null && res.user!.userName != "") {
      await SharedPref()
          .setPreferencesString(Constants.name, res.user!.userName.toString());
    }
  }

  List<UserService> allUsers = [];
  getAllUsersData(event, emit) async {
    emit(FetchProfileDataState(response: AuthResponse(isLoad: true)));
    try {
      var res = await getAllUsersUseCase();
      res.fold((l) {
        emit(FetchProfileDataState(
            response: AuthResponse(isFailed: true, msg: l.toString())));
      }, (data) async {
        if (data.isNotEmpty) {
          allUsers = data;
          emit(FetchProfileDataState(response: AuthResponse(isSuccess: true)));
        }
      });
    } catch (e) {
      emit(FetchProfileDataState(
          response: AuthResponse(isFailed: true, msg: e.toString())));
    }
  }

  bool isEnabledNotification = false;
  changeNotificationMode(event, emit) {
    emit(AccountInitialState());
    isEnabledNotification = !isEnabledNotification;
    emit(const UpdateNotificationsModeState());
  }

  bool isOnline = false;
  changeNurseProfileStatus(SwitchProfileStatusEvent event, emit) async {
    emit(AccountInitialState());
    try {
      if (event.isOnline != null) isOnline = event.isOnline!;
      var res = await updateProfileStatusUseCase(
          userData: {'status': isOnline == true ? "offline" : "online"});
      res.fold((l) {
        emit(const ProfileFailedState());
      }, (data) {
        if (data) {
          isOnline = !isOnline;
          emit(const ProfileSuccessState());
        }
      });
    } catch (e) {
      isOnline = false;
      emit(const ProfileFailedState());
    }
  }

  List<MedicalReportEntity> patientMedicalReports = [];
  createMedicalReport(CreateMedicalReportEvent event, emit) async {
    emit(const MedicalReportLoadingState());
    try {
      var res = await createMedicalReportUseCase(
        data: event.data,
        prescriptionImage: event.prescriptionImage,
      );
      res.fold(
        (l) => emit(MedicalReportErrorState(error: l.toString())),
        (data) => emit(const MedicalReportCreatedState()),
      );
    } catch (e) {
      emit(MedicalReportErrorState(error: e.toString()));
    }
  }

  fetchPatientMedicalReports(
      FetchPatientMedicalReportsEvent event, emit) async {
    emit(const MedicalReportLoadingState());
    try {
      var res = await getPatientMedicalReportsUseCase(event.patientId);
      res.fold(
        (l) => emit(MedicalReportErrorState(error: l.toString())),
        (data) {
          patientMedicalReports = data;
          emit(const MedicalReportsLoadedState());
        },
      );
    } catch (e) {
      emit(MedicalReportErrorState(error: e.toString()));
    }
  }

  deleteAccount(DeleteAccountEvent event, emit) async {
    emit(const DeleteAccountLoadingState());
    try {
      final result = await deleteAccountUseCase.call(event.userId);
      await result.fold((failure) async {
        emit(DeleteAccountFailedState(message: failure.toString()));
      }, (message) async {
        await TokenStorageHelper.deleteToken();
        await SharedPref().removePreference(Constants.userId);
        await SharedPref().removePreference(Constants.apiToken);
        await SharedPref().removePreference(Constants.userType);
        await SharedPref().removePreference(Constants.email);
        await SharedPref().removePreference(Constants.name);
        await SharedPref().removePreference(Constants.mobile);
        await SharedPref().removePreference(Constants.city);
        await SharedPref().removePreference(Constants.address);
        await SharedPref().removePreference(Constants.userLatitude);
        await SharedPref().removePreference(Constants.userLongitude);
        await SharedPref().removePreference(Constants.token);
        currentUser = null;
        emit(DeleteAccountSuccessState(message: message));
      });
    } catch (e) {
      emit(DeleteAccountFailedState(message: e.toString()));
    }
  }

  updateCurrentPatientData(UpdateUserPatientDataEvent event, emit) {
    emit(AccountInitialState());
    // Note: UserService fields are final. Local updates should ideally use copyWith.
    // For now, we emit the state with the new data which will be fetched from API later.
    emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
  }

  Future<void> modifyCurrentService(
      ModifyCurrentService event, Emitter<AccountState> emit) async {
    emit(const ProfileLoadingState());

    if (Util.isDoctor()) {
      if (event.isRemove == true) {
        selectedSpecialty = null;
      } else {
        selectedSpecialty = SpecialtyEntity(
          id: event.item.id,
          title: event.item.value.toString(),
        );
      }

      final result = await updateDoctorOptionsUseCase(options: {
        'specialties_id': selectedSpecialty?.id,
      });

      result.fold(
        (failure) => emit(const ProfileFailedState()),
        (success) => emit(const ProfileSuccessState()),
      );
    } else {
      servicesList ??= [];
      if (event.isRemove == true) {
        servicesList!.removeWhere((element) => element.id == event.item.id);
      } else {
        int index =
            servicesList!.indexWhere((element) => element.id == event.item.id);
        if (index != -1) {
          servicesList![index] = event.item;
        } else {
          servicesList!.add(event.item);
        }
      }

      final result = await updateNurseOptionsUseCase(options: {
        'services':
            ServiceToApiConverter.convertServicesToPayload(servicesList!),
      });

      result.fold(
        (failure) => emit(const ProfileFailedState()),
        (success) => emit(const ProfileSuccessState()),
      );
    }
    currentModifyService = null;
  }

  enableModifyCurrentService(EnableModifyCurrentService event, emit) {
    emit(AccountInitialState());
    currentModifyService = event.item;
    emit(const UpdateNotificationsModeState()); // UI refresh
  }

  String convertAllergiesToIDS() {
    if (currentUser == null ||
        currentUser!.allergiesList == null ||
        currentUser!.allergiesList!.isEmpty) {
      return "";
    }
    return currentUser!.allergiesList!.map((e) => e.id).join(',');
  }

  Future<void> switchCurrentUserWithPatientProfile(
      String userId, String type) async {
    // This is used by nurses to view/edit patient data during an order
    // We fetch the patient data and set it as currentUser temporarily
    try {
      var res = await getUserFullDataUseCase(userId: userId);
      res.fold((l) => null, (data) {
        currentUser = data;
        // Update local state variables
        emergencyContactsList = currentUser!.emergencyContactsList;
        if (currentUser!.nurse != null) {
          servicesList = currentUser!.nurse!.servicesList;
        }
      });
    } catch (e) {
      // Error switching profile
    }
  }
}
