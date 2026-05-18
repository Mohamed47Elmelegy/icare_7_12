import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:icare/features/account/domain/use_cases/get_services_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_doctor_options_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_nurse_options_usecase.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/setting/domain/use_cases/get_specialties_usecase.dart';
import 'package:icare/features/setting/domain/use_cases/notifications_usecase.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServicesUseCase getServicesUseCase;
  final GetSpecialtiesUseCase getSpecialtiesUseCase;
  final UpdateNurseOptionsUseCase updateNurseOptionsUseCase;
  final UpdateDoctorOptionsUseCase updateDoctorOptionsUseCase;
  StreamSubscription<RemoteMessage>? _notificationSubscription;
  final GetAllNotificationsUseCase getAllNotificationsUseCase;

  ServicesBloc({
    required this.getServicesUseCase,
    required this.getSpecialtiesUseCase,
    required this.updateNurseOptionsUseCase,
    required this.updateDoctorOptionsUseCase,
    required this.getAllNotificationsUseCase,
  }) : super(ServicesInitial()) {
    // 🔔 Listen for notifications to refresh notifications list automatically
    _notificationSubscription =
        NotificationsUtils.notificationStream.stream.listen((message) {
      // Notification received, refreshing notification list
      add(const FetchAllNotificationsEvent());
    });

    on<FetchAllServicesEvent>((event, emit) async {
      await _getAllServiceList(event, emit);
    });

    on<FetchAllNotificationsEvent>((event, emit) async {
      await _getAllNotifications(event, emit);
    });

    on<ChangeCurrentService>((event, emit) {
      _changeCurrentService(event, emit);
    });
  }

  static ServicesBloc get(BuildContext context) => BlocProvider.of(context);

  List<ServicesModel> allServiceList = [];
  List<SpecialtyEntity> allSpecialtiesList = [];
  List<NotificationsEntity> notificationList = [];
  ServicesModel? currentService;
  String? priceTxt;
  int? currentModifyService;

  Future<void> _getAllServiceList(
      FetchAllServicesEvent event, Emitter<ServicesState> emit) async {
    // ServicesBloc received FetchAllServicesEvent


    // 🛡️ DEDUPLICATION: Prevent multiple simultaneous loads
    if (state is ServicesLoading) {
      // Already loading, ignoring duplicate event
      return;
    }

    if (!Util.checkUser()) {
      // No user logged in, aborting
      return;
    }

    emit(ServicesLoading());
    // Emitted ServicesLoading


    String? userType = event.userType;

    // Resolve userType from local storage if not provided
    if (userType == null || userType.isEmpty) {
      userType = Util.getUserType();
      // Resolved userType from storage

    }

    if (userType == 'doctor') {
      // Fetching SPECIALTIES for doctor

      final result = await getSpecialtiesUseCase();
      result.fold(
        (failure) {
          allSpecialtiesList = [];
          emit(const ServicesError("Failed to load specialties"));
        },
        (specialties) {
          allSpecialtiesList = specialties;
          // Successfully loaded specialties
          emit(ServicesSuccess());
          // Emitted ServicesSuccess (Specialties)
        },
      );
    } else {
      // Fetching SERVICES for userType

      final result = await getServicesUseCase(userType: userType);
      result.fold(
        (failure) {
          allServiceList = [];
          emit(const ServicesError("Failed to load services"));
        },
        (services) {
          allServiceList = services;
          // Successfully loaded services
          emit(ServicesSuccess());
          // Emitted ServicesSuccess (Services)
        },
      );
    }
  }

  Future<void> _getAllNotifications(
      FetchAllNotificationsEvent event, Emitter<ServicesState> emit) async {
    if (state is NotificationsLoading) return;
    if (!Util.checkUser()) return;

    emit(NotificationsLoading());
    final result = await getAllNotificationsUseCase();
    result.fold(
      (failure) {
        emit(const ServicesError("Failed to load notifications"));
      },
      (notifications) {
        notificationList = notifications.toList();
        emit(NotificationsSuccess());
      },
    );
  }

  void _changeCurrentService(
      ChangeCurrentService event, Emitter<ServicesState> emit) {
    currentService = event.item;
    if (event.txt != null) priceTxt = event.txt;
    emit(ServicesSuccess());
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
