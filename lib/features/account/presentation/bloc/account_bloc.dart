import 'dart:async';
import 'dart:io';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/domain/use_cases/get_all_users_usecase.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/setting/domain/use_cases/notifications_usecase.dart';
import 'package:icare/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';
import 'package:icare/features/account/domain/usecases/create_medical_report_usecase.dart';
import 'package:icare/features/account/domain/usecases/get_patient_medical_reports_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/domain/use_cases/change_password_usercase.dart';
import 'package:icare/features/account/domain/use_cases/get_user_service_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_user_usecase.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  bool showPassword = false;
  static AccountBloc get(BuildContext context) => BlocProvider.of(context);

  GetUserServiceUseCase getUserServiceUseCase;
  ChangePasswordUseCase changePasswordUseCase;
  UpdateUserServiceUseCase updateUserServiceUseCase;
  GetAllNotificationsUseCase getAllNotificationsUseCase;
  GetAllUsersUseCase getAllUsersUseCase;
  UpdateProfileStatusUseCase updateProfileStatusUseCase;
  CreateMedicalReportUseCase createMedicalReportUseCase;
  GetPatientMedicalReportsUseCase getPatientMedicalReportsUseCase;

  AccountBloc({
    required this.getUserServiceUseCase,
    required this.updateUserServiceUseCase,
    required this.changePasswordUseCase,
    required this.getAllNotificationsUseCase,
    required this.getAllUsersUseCase,
    required this.updateProfileStatusUseCase,
    required this.createMedicalReportUseCase,
    required this.getPatientMedicalReportsUseCase,
  }) : super(AccountInitialState()) {
    on<UpdateProfileEvent>((event, emit) async {
      await updateProfile(event, emit);
      await getProfileData(event, emit);
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

    on<FetchAllNotificationsEvent>((event, emit) async {
      await getAllNotifications(event, emit);
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

    /// nurse section
    on<UpdateNurseDataEvent>((event, emit) {
      updateNurseData(event, emit);
    });

    on<UpdateDoctorDataEvent>((event, emit) {
      updateDoctorData(event, emit);
    });

    on<ChangeCurrentService>((event, emit) {
      changeCurrentService(event, emit);
    });

    on<EnableModifyCurrentService>((event, emit) {
      enableModifyService(event, emit);
    });

    on<ModifyCurrentService>((event, emit) {
      modifyCurrentService(event, emit);
    });

    on<SwitchProfileStatusEvent>((event, emit) async {
      await changeNurseProfileStatus(event, emit);
    });

    on<FetchAllServicesEvent>((event, emit) async {
      await getAllServiceList(event, emit);
    });

    on<CreateMedicalReportEvent>((event, emit) async {
      await createMedicalReport(event, emit);
    });

    on<FetchPatientMedicalReportsEvent>((event, emit) async {
      await fetchPatientMedicalReports(event, emit);
    });
  }

  bool enableUpdate = false;
  bool enableUpdateImg = false;
  enableUpdateProfile(EnableUpdateProfileEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.isImg == true) {
      enableUpdateImg = !enableUpdateImg;
    } else if (event.isSave == true) {
      enableUpdate = false;
      enableUpdateImg = false;
      currentModifyService = null;
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

  /// nurse section

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
  updateNurseData(UpdateNurseDataEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.nurse != null) nurse = event.nurse;
    if (event.license != null) license = event.license;
    if (event.certificate != null) certificate = event.certificate;
    if (event.nurseID != null) nurseID = event.nurseID;
    if (event.associationCard != null) associationCard = event.associationCard;
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
    Timer(const Duration(seconds: 1), () async {
      await UserServiceRemoteDataSource.updateNurseOptionsValue(userData: {
        if (languageList != null) 'languages': languageList,
        if (educationList != null) 'education': educationList,
        if (publicationsList != null) 'publications': publicationsList,
        if (coursesList != null) 'courses': coursesList,
        if (emergencyContactsList != null)
          'emergency_contacts': emergencyContactsList,
        if (servicesList != null && event.servicesList != null)
          'services': convertServiceToIDS(event.servicesList!),
      });
    });
    _afterUpdateProfile();
    emit(const UpdateNurseDataSuccessState());
  }

  updateDoctorData(UpdateDoctorDataEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.doctor != null) doctor = event.doctor;
    if (event.license != null) license = event.license;
    if (event.certificate != null) certificate = event.certificate;
    if (event.doctorID != null) doctorID = event.doctorID;
    if (event.associationCard != null) associationCard = event.associationCard;
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
    Timer(const Duration(seconds: 1), () async {
      await UserServiceRemoteDataSource.updateDoctorOptionsValue(userData: {
        if (languageList != null) 'languages': languageList,
        if (educationList != null) 'education': educationList,
        if (publicationsList != null) 'publications': publicationsList,
        if (coursesList != null) 'courses': coursesList,
        if (emergencyContactsList != null)
          'emergency_contacts': emergencyContactsList,
        if (servicesList != null && event.servicesList != null)
          'services': convertServiceToIDS(event.servicesList!),
      });
    });
    _afterUpdateProfile();
    emit(const UpdateDoctorDataSuccessState());
  }

  changeUserPassword(ChangeUserPasswordEvent event, emit) async {
    emit(ChangeUserPasswordState(response: AuthResponse(isLoad: true)));
    String resMsg = "";
    try {
      var res = await changePasswordUseCase(data: event.data);
      res.fold((l) {
        resMsg = l.toString();
        emit(ChangeUserPasswordState(
            response: AuthResponse(isFailed: true, msg: resMsg)));
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
      debugPrint("changeUserPassword: $e");
    }
  }

  UserService? currentModifiedUser;
  File? avatar;
  updateCurrentUserData(UpdateProfileCurrentDataEvent event, emit) {
    emit(const ProfileLoadingState());
    if (event.userData['avatar'] != null) avatar = event.userData['avatar'];
    emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
  }

  updateProfile(UpdateProfileEvent event, emit) async {
    if (!Util.checkUser()) return;
    emit(UpdateProfileState(response: AuthResponse(isLoad: true)));
    String resMsg = "";
    try {
      var res = await updateUserServiceUseCase(userData: event.user);
      res.fold((l) {
        resMsg = l.toString();
      }, (data) async {
        if (data.userId != 0) {
          currentUser = data;
          _afterUpdateProfile();
          emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
          await saveUserDate(AuthResponse(user: data));
        } else {
          resMsg = translate("toast.wrong");
        }
      });
    } catch (e) {
      emit(UpdateProfileState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
      debugPrint("updateProfile: $e");
    }
  }

  _afterUpdateProfile() {
    enableUpdate = false;
    enableUpdateImg = false;
    currentPublication = "";
    currentMedicalConditions = "";
  }

  UserService? currentUser;
  getProfileData(event, emit) async {
    if (!Util.checkUser()) return;
    emit(FetchProfileDataState(response: AuthResponse(isLoad: true)));
    String resMsg = "";
    try {
      var res = await getUserServiceUseCase();
      res.fold((l) {
        resMsg = l.toString();
      }, (data) async {
        if (data.userId != null && data.userId != 0) {
          currentUser = data;
          isOnline = currentUser!.status ?? false;
          emergencyContactsList = currentUser!.emergencyContactsList;

          // Load nurse data if exists
          if (currentUser!.nurse != null) {
            var nurse = currentUser!.nurse;
            languageList = nurse!.languageList;
            educationList = nurse.educationList;
            publicationsList = nurse.publicationsList;
            coursesList = nurse.coursesList;
            servicesList = nurse.servicesList;
          }

          // Load doctor data if exists
          if (currentUser!.doctor != null) {
            var doctor = currentUser!.doctor;
            languageList = doctor!.languageList;
            educationList = doctor.educationList;
            publicationsList = doctor.publicationsList;
            coursesList = doctor.coursesList;
            servicesList = doctor.servicesList;
          }

          _afterUpdateProfile();
          add(const FetchAllServicesEvent());
          emit(UpdateProfileState(response: AuthResponse(isSuccess: true)));
          await saveUserDate(
              AuthResponse(user: data, isSuccess: true, msg: resMsg));
        }
      });
    } catch (e) {
      emit(FetchProfileDataState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
      debugPrint("getProfileDataBlocError: $e");
    }
  }

  saveUserDate(AuthResponse res) async {
    if (res.user == null) return;
    if (res.user!.userId == null) {
      await SharedPref()
          .setPreferencesString(Constants.userId, res.user!.userId.toString());
    }
    if (res.user!.email == null && res.user!.email != "") {
      await SharedPref()
          .setPreferencesString(Constants.email, res.user!.email.toString());
    }
    if (res.user!.phoneNumber == null && res.user!.phoneNumber != "") {
      await SharedPref().setPreferencesString(
          Constants.mobile, res.user!.phoneNumber.toString());
    }
    if (res.user!.userName == null && res.user!.userName != "") {
      await SharedPref()
          .setPreferencesString(Constants.name, res.user!.userName.toString());
    }
  }

  /// get all users
  List<UserService> allUsers = [];
  getAllUsersData(event, emit) async {
    emit(FetchProfileDataState(response: AuthResponse(isLoad: true)));
    String resMsg = "";
    try {
      var res = await getAllUsersUseCase();
      res.fold((l) {
        resMsg = l.toString();
        emit(FetchProfileDataState(response: AuthResponse(isFailed: true)));
      }, (data) async {
        if (data.isNotEmpty) {
          allUsers = data;
          emit(FetchProfileDataState(response: AuthResponse(isSuccess: true)));
        }
      });
    } catch (e) {
      emit(FetchProfileDataState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
      debugPrint("getProfileDataBlocError: $e");
    }
  }

  /// notifications
  List<NotificationsEntity> notificationList = [];
  getAllNotifications(event, emit) async {
    if (!Util.checkUser()) return;
    // try{
    emit(const FetchNotificationsLoadingState());
    var res = await getAllNotificationsUseCase();
    res.fold((l) {
      emit(const FetchNotificationsFailedState());
    }, (data) {
      notificationList = data.reversed.toList();
      emit(const FetchNotificationsSuccessfullyState());
    });
    // }catch(e){
    //   debugPrint("getAllNotifications: $e");
    //   emit(const FetchNotificationsFailedState());
    // }
  }

  bool isEnabledNotification = false;
  changeNotificationMode(event, emit) {
    emit(AccountInitialState());
    isEnabledNotification = !isEnabledNotification;
    emit(const UpdateNotificationsModeState());
  }

  /// send fcm token
  updateFcmToken() async {
    // await UserServiceRemoteDataSource.updateUserToken();
  }

  /// patientData
  String currentPublication = "";
  String currentMedicalConditions = "";
  updateCurrentPatientData(UpdateUserPatientDataEvent event, emit) {
    emit(AccountInitialState());
    if (event.data['publications'] != null) {
      currentPublication = event.data['publications'];
    }
    if (event.data['medical_conditions'] != null) {
      currentMedicalConditions = event.data['medical_conditions'];
    }
    emit(const ProfileSuccessState());
  }

  convertAllergiesToIDS() {
    var list = [];
    for (var i in currentUser!.allergiesList!) {
      list.add(i.id);
    }
    return list;
  }

  List<ServicesModel> allServiceList = [];
  getAllServiceList(
      FetchAllServicesEvent event, Emitter<AccountState> emit) async {
    if (!Util.checkUser()) return;

    emit(const ProfileLoadingState());

    String? userType = event.userType;

    // Get user_type from current user or nurse profile if not provided
    if (userType == null) {
      if (currentUser?.nurse?.type != null) {
        userType = currentUser!.nurse!.type;
        debugPrint("🔍 Using specific NURSE type: $userType");
      } else if (currentUser?.userType != null) {
        userType = currentUser!.userType;
        debugPrint("🔍 Using generic user type: $userType");
      }
    }

    if (userType == 'doctor') {
      debugPrint("🔍 Fetching SPECIALTIES for doctor");
      try {
        var specialties = await SettingsRemoteDataSource.fetchAllSpecialties();
        allServiceList = specialties
            .map((s) => ServicesModel(
                  id: s.id,
                  value: s.title,
                  name: s.title,
                  userType: 'doctor',
                ))
            .toList();
        debugPrint(
            "✅ Loaded ${allServiceList.length} specialties for doctor as services");
      } catch (e) {
        debugPrint("❌ Error fetching specialties: $e");
        allServiceList = [];
      }
    } else {
      allServiceList = await UserServiceRemoteDataSource.getAllServicesList(
          userType: userType);
      debugPrint(
          "📋 Loaded ${allServiceList.length} services for user_type: ${userType ?? 'all'}");
    }
    emit(const ProfileSuccessState());
  }

  ServicesModel? currentService;
  String? priceTxt;
  changeCurrentService(ChangeCurrentService event, emit) {
    emit(AccountInitialState());
    currentService = event.item;
    if (event.txt != null) priceTxt = event.txt;
    emit(const ProfileSuccessState());
  }

  int? currentModifyService;
  enableModifyService(EnableModifyCurrentService event, emit) {
    emit(AccountInitialState());
    currentModifyService = event.item;
    emit(const ProfileSuccessState());
  }

  modifyCurrentService(ModifyCurrentService event, emit) {
    emit(AccountInitialState());
    currentModifyService = null;
    if (servicesList == null) return;
    int indexI =
        servicesList!.indexWhere((element) => element.id == event.item.id);
    if (event.isRemove == true) {
      if (indexI == -1) return;
      servicesList!.removeAt(indexI);
    } else {
      servicesList![indexI] = event.item;
    }
    if (Util.isDoctor()) {
      UserServiceRemoteDataSource.updateDoctorOptionsValue(userData: {
        if (servicesList != null)
          'services': convertServiceToIDS(servicesList!),
      });
    } else {
      UserServiceRemoteDataSource.updateNurseOptionsValue(userData: {
        if (servicesList != null)
          'services': convertServiceToIDS(servicesList!),
      });
    }
    emit(const ProfileSuccessState());
  }

  convertServiceToIDS(List<ServicesModel> listP) {
    var list = [];
    for (var i in listP) {
      list.add({
        'id': i.id,
        'value': i.value,
      });
    }
    return list;
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
      debugPrint("changeNurseProfileStatus: $e");
      isOnline = false;
      emit(const ProfileFailedState());
    }
  }

  switchCurrentUserWithPatientProfile(String id, String userType) async {
    // Update SharedPreferences to switch user context
    await SharedPref().setPreferencesString(Constants.userId, id);
    await SharedPref().setPreferencesString(Constants.userType, userType);

    debugPrint("✅ Switched to user ID: $id, type: $userType");
    // Note: ApiUrl.headerAuth is now a dynamic getter that will automatically
    // use the updated user ID and token from SharedPreferences
  }

  /// Medical Reports Section
  List<MedicalReportEntity> patientMedicalReports = [];

  createMedicalReport(CreateMedicalReportEvent event, emit) async {
    emit(const MedicalReportLoadingState());
    try {
      var res = await createMedicalReportUseCase(
        data: event.data,
        prescriptionImage: event.prescriptionImage,
      );
      res.fold(
        (l) {
          debugPrint("❌ Create Medical Report Failed: $l");
          emit(MedicalReportErrorState(error: l.toString()));
        },
        (data) {
          debugPrint("✅ Medical Report Created: ${data.id}");
          emit(const MedicalReportCreatedState());
        },
      );
    } catch (e) {
      debugPrint("❌ Create Medical Report Error: $e");
      emit(MedicalReportErrorState(error: e.toString()));
    }
  }

  fetchPatientMedicalReports(
      FetchPatientMedicalReportsEvent event, emit) async {
    emit(const MedicalReportLoadingState());
    try {
      var res = await getPatientMedicalReportsUseCase(event.patientId);
      res.fold(
        (l) {
          debugPrint("❌ Fetch Medical Reports Failed: $l");
          emit(MedicalReportErrorState(error: l.toString()));
        },
        (data) {
          debugPrint("✅ Fetched ${data.length} Medical Reports");
          patientMedicalReports = data;
          emit(const MedicalReportsLoadedState());
        },
      );
    } catch (e) {
      debugPrint("❌ Fetch Medical Reports Error: $e");
      emit(MedicalReportErrorState(error: e.toString()));
    }
  }
}
