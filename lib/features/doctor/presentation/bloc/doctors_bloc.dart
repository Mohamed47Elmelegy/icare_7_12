import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/doctor/domain/use_cases/get_all_doctors_usecase.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/screens/doctor_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  GetAllDoctorsUseCase getAllDoctorsUseCase;
  RateDoctorUseCase rateDoctorUseCase;

  DoctorBloc({
    required this.getAllDoctorsUseCase,
    required this.rateDoctorUseCase,
  }) : super(DoctorInitialState()) {
    on<FetchAllDoctorEvent>((event, emit) async {
      await getAllDoctors(event, emit);
    });

    on<RateDoctorEvent>((event, emit) async {
      await rateDoctor(event, emit);
    });

    on<UpdateCurrentDoctorEvent>((event, emit) async {
      updateCurrentDoctor(event, emit);
    });

    on<ShowNearbyDoctorsEvent>((event, emit) async {
      showNearbyListFn(event, emit);
    });

    on<UpdateSearchTxtEvent>((event, emit) async {
      updateSearchText(event, emit);
    });

    on<UpdateRateDataEvent>((event, emit) async {
      updateRateData(event, emit);
    });

    on<ShowAllDoctorsEvent>((event, emit) async {
      showAllDoctorsFn(event, emit);
    });

    on<SetDoctorOnMapEvent>((event, emit) async {
      await setDoctorOnMapFn(event, emit);
    });
  }

  static DoctorBloc get(BuildContext context) => BlocProvider.of(context);

  String searchText = '';
  updateSearchText(UpdateSearchTxtEvent event, emit) {
    emit(DoctorInitialState());
    searchText = event.txt;
    emit(FetchAllDoctorsSuccessfullyState());
  }

  String rateTxt = "";
  double rateValue = 0;
  updateRateData(UpdateRateDataEvent event, emit) {
    emit(UpdateRateDataState());
    if (event.rateTxt != null) rateTxt = event.rateTxt!;
    if (event.rateValue != null) rateValue = event.rateValue!;
    emit(UpdateRateDataState());
  }

  rateDoctor(RateDoctorEvent event, emit) async {
    emit(RateDataLoadingState());
    var res = await rateDoctorUseCase(data: event.data);
    res.fold((l) {
      emit(FetchAllDoctorsFailedState());
    }, (data) {
      if (data) {
        emit(AddDoctorRateSuccessfullyState());
      }
    });
  }

  List<DoctorEntity> doctorsList = [];
  getAllDoctors(FetchAllDoctorEvent event, emit) async {
    if (event.page == 1) {
      doctorsList.clear();
    } else if (doctorsList.length > 50) {
      return;
    }
    emit(FetchAllDoctorsLoadingState());
    var res = await getAllDoctorsUseCase(data: {'page': event.page});
    res.fold((l) {
      emit(FetchAllDoctorsFailedState());
    }, (data) {
      if (data.isNotEmpty) {
        doctorsList.addAll(data);
      }
      if (event.page == 1) nearbyList = data;
      emit(FetchAllDoctorsSuccessfullyState());
    });
  }

  bool showAllDoctors = false;
  showAllDoctorsFn(ShowAllDoctorsEvent event, emit) {}

  List<DoctorEntity> nearbyList = [];

  bool showNearbyList = false;
  showNearbyListFn(event, emit) {
    emit(DoctorInitialState());
    showNearbyList = !showNearbyList;
    emit(FetchAllDoctorsSuccessfullyState());
  }

  DoctorEntity? currentDoctor;
  updateCurrentDoctor(UpdateCurrentDoctorEvent event, emit) {
    emit(FetchAllDoctorsLoadingState());
    currentDoctor = event.doctor;
    emit(FetchAllDoctorsSuccessfullyState());
  }

  Timer? markersTimer;
  int filteredResultsCount = 0;
  String? currentFilterType;

  setDoctorOnMapFn(SetDoctorOnMapEvent event, emit) async {
    emit(FetchAllDoctorsLoadingState());
    List<Marker> markersToAdd = [];
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    AuthBloc.get(event.ctx).markers.clear();
    try {
      // Check if location services are enabled once
      if (!await Permission.location.serviceStatus.isEnabled) {
        await Permission.location.request();
      }
      showAllDoctors = event.showAllDoctors == true ? true : false;
      emit(FetchAllDoctorsSuccessfullyState());

      var list = doctorsList;

      // Store current filter type
      currentFilterType = event.userType;

      // Filter by userType if provided
      if (event.userType != null && event.userType!.isNotEmpty) {
        list = list.where((doctor) {
          return doctor.userData?.userType?.toLowerCase() == event.userType!.toLowerCase();
        }).toList();
      }

      // Filter by serviceIds if provided
      if (event.serviceIds != null && event.serviceIds!.isNotEmpty) {
        list = list.where((doctor) {
          if (doctor.servicesList == null || doctor.servicesList!.isEmpty) {
            return false;
          }
          return doctor.servicesList!.any((service) => event.serviceIds!.contains(service.id));
        }).toList();
      }

      // Store filtered results count
      filteredResultsCount = list.length;
      debugPrint('show all doctors: $showAllDoctors for list:${list.length}');

      for (var i in list) {
        if (markersTimer == null || !markersTimer!.isActive) {
          debugPrint("search screen not available now");
          return;
        }

        // Ensure user data is valid
        if (i.userData != null &&
            i.userData!.lat != null &&
            i.userData!.long != null &&
            i.userData!.lat != 0.0 &&
            i.userData!.long != 0.0) {
          var point = LatLng(i.userData!.lat!, i.userData!.long!);

          MarkerId markerId = MarkerId("${i.userData!.isWomen == true ? "isWomen" : "isMan"}-${i.id}");
          Marker marker = Marker(
            markerId: markerId,
            position: point,
            onTap: () {},
            infoWindow: InfoWindow(
              title: "${i.userData!.userName} ${ReviewModel.calcReviewStar(i.reviewList!)}",
              snippet: LocationUtil.getDistanceView(i.distanceKM, i.distanceM),
              onTap: () {
                DoctorBloc.get(event.ctx).add(UpdateCurrentDoctorEvent(doctor: i));
                if (event.ctx.mounted) {
                  Util.pushPage(const DoctorDetails(), event.ctx);
                }
              },
            ),
            icon: showAllDoctors
                ? await BitmapDescriptor.asset(
                    const ImageConfiguration(size: Size(40, 40)),
                    i.userData!.isWomen == true ? "assets/images/doctor_test.png" : "assets/images/avatar.png")
                : await LocationUtil.convertImageFileToCustomBitmapDescriptor(i.userData!.image.toString()),
          );

          markersToAdd.add(marker);
          markers.addAll({for (var marker in markersToAdd) marker.markerId: marker});
          await Future.delayed(const Duration(milliseconds: 300));
          if (event.ctx.mounted) {
            AuthBloc.get(event.ctx).add(UpdateMarkersEvent(markers: markers));
          }
          debugPrint("------------------add new markerID: $markerId ");
        }
      }
    } catch (e) {
      debugPrint("_setLocationOnMap: $e");
    }
  }
}
