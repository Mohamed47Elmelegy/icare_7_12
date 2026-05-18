import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/domain/use_cases/get_all_nurses_usecase.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class NurseBloc extends Bloc<NurseEvent, NurseState> {
  GetAllNursesUseCase getAllNursesUseCase;
  RateNurseUseCase rateNurseUseCase;
  NurseBloc({
    required this.getAllNursesUseCase,
    required this.rateNurseUseCase,
  }) : super(NurseInitialState()) {
    on<FetchAllNurseEvent>((event, emit) async {
      await getAllNurses(event, emit);
    });

    on<RateNurseEvent>((event, emit) async {
      await rateNurse(event, emit);
    });

    on<UpdateCurrentNurseEvent>((event, emit) async {
      updateCurrentNurse(event, emit);
    });

    // on<AddNewNearbyNurseEvent>((event, emit)async{
    //   addNearbyNurse(event,emit);
    // });

    on<ShowNearbyNursesEvent>((event, emit) async {
      showNearbyListFn(event, emit);
    });

    on<UpdateSearchTxtEvent>((event, emit) async {
      updateSearchText(event, emit);
    });

    on<UpdateRateDataEvent>((event, emit) async {
      updateRateData(event, emit);
    });

    on<ShowAllNursesEvent>((event, emit) async {
      showAllNursesFn(event, emit);
    });

    on<SetNurseOnMapEvent>((event, emit) async {
      await setNurseOnMapFn(event, emit);
    });
  }
  static NurseBloc get(BuildContext context) => BlocProvider.of(context);

  String searchText = '';
  updateSearchText(UpdateSearchTxtEvent event, emit) {
    emit(NurseInitialState());
    searchText = event.txt;
    emit(FetchAllNursesSuccessfullyState());
  }

  String rateTxt = "";
  double rateValue = 0;
  updateRateData(UpdateRateDataEvent event, emit) {
    emit(UpdateRateDataState());
    if (event.rateTxt != null) rateTxt = event.rateTxt!;
    if (event.rateValue != null) rateValue = event.rateValue!;
    emit(UpdateRateDataState());
  }

  rateNurse(RateNurseEvent event, emit) async {
    emit(RateDataLoadingState());
    // try{
    var res = await rateNurseUseCase(data: event.data);
    res.fold((l) {
      emit(FetchAllNursesFailedState());
    }, (data) {
      if (data) {
        emit(AddNurseRateSuccessfullyState());
      }
    });
    // }catch(e){
    //   // getAllNursesBlocError
    //   emit(FetchAllNursesFailedState());
    // }
  }

  List<NurseEntity> nursesList = [];
  getAllNurses(FetchAllNurseEvent event, emit) async {
    if (nursesList.length > 50) return;
    emit(FetchAllNursesLoadingState());
    // try{
    var res = await getAllNursesUseCase(data: {'page': event.page});
    res.fold((l) {
      emit(FetchAllNursesFailedState());
    }, (data) {
      if (data.isNotEmpty) {
        nursesList.addAll(data);
      }
      if (event.page == 1) nearbyList = data;
      emit(FetchAllNursesSuccessfullyState());
    });
    // }catch(e){
    //   // getAllNursesBlocError
    //   emit(FetchAllNursesFailedState());
    // }
  }

  bool showAllNurses = false;
  showAllNursesFn(ShowAllNursesEvent event, emit) {
    // emit(FetchAllNursesFailedState());
    // showAllNurses = !showAllNurses;
    // emit(FetchAllNursesFailedState());
  }

  List<NurseEntity> nearbyList = [];
  // addNearbyNurse(AddNewNearbyNurseEvent event,emit){
  //   emit(FetchAllNursesLoadingState());
  //   var res = checkIfNurseNearby(event.distance!);
  //   if(res.first!="" || res.last!=""){
  //     int index = nearbyList.indexWhere((element) => element.userData!.userId == event.nurse!.userData!.userId);
  //     if(index!=-1||res.first=='-1')return;
  //     nearbyList.add(NurseEntity(id: event.nurse!.id, userData: event.nurse!.userData,distanceKM: double.parse(res.first==""?"-1":res.first),distanceM: double.parse(res.last)));
  //   }
  //   emit(FetchAllNursesSuccessfullyState());
  // }

  // List checkIfNurseNearby(String distance){
  //   if(distance=="")return ["",""];
  //   String m = distance.trim().split("km").last.split('m').first.trim();
  //   if(distance.contains("km") && double.parse(distance.trim().split("km").first.trim())<=5){
  //     //return km && m
  //     return [distance.trim().split("km").first.trim(),m];
  //   }else if(distance.contains("km") && double.parse(distance.trim().split("km").first.trim())>5){
  //      //return -1 if kilometer above 5 km so it will be ignore
  //     return ["-1",m];
  //   }else{
  //     //return just has meter value
  //     return ["",m];
  //   }
  // }

  bool showNearbyList = false;
  showNearbyListFn(event, emit) {
    emit(NurseInitialState());
    showNearbyList = !showNearbyList;
    emit(FetchAllNursesSuccessfullyState());
  }

  NurseEntity? currentNurse;
  updateCurrentNurse(UpdateCurrentNurseEvent event, emit) {
    emit(FetchAllNursesLoadingState());
    currentNurse = event.nurse;
    emit(FetchAllNursesSuccessfullyState());
  }

  Timer? markersTimer;
  int filteredResultsCount = 0;
  String? currentFilterType;

  setNurseOnMapFn(SetNurseOnMapEvent event, emit) async {
    emit(FetchAllNursesLoadingState());
    List<Marker> markersToAdd = [];
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    try {
      // Check if location services are enabled once
      if (!await Permission.location.serviceStatus.isEnabled) {
        await Permission.location.request();
      }
      showAllNurses = event.showAllNurses == true ? true : false;
      emit(FetchAllNursesSuccessfullyState());

      // 🔧 FIX: Always use nursesList regardless of showAllNurses
      // nearbyList was empty causing 0 results after filtering
      var list = nursesList;

      // Store current filter type
      currentFilterType = event.userType;

      // Filter by userType if provided
      if (event.userType != null && event.userType!.isNotEmpty) {
        list = list.where((nurse) {
          return nurse.userData?.userType?.toLowerCase() ==
              event.userType!.toLowerCase();
        }).toList();
      }

      // Filter by serviceIds if provided
      if (event.serviceIds != null && event.serviceIds!.isNotEmpty) {
        list = list.where((nurse) {
          if (nurse.servicesList == null || nurse.servicesList!.isEmpty) {
            return false;
          }
          return nurse.servicesList!
              .any((service) => event.serviceIds!.contains(service.id));
        }).toList();
      }

      // Store filtered results count
      filteredResultsCount = list.length;

      for (var i in list) {
        // if (event.ctx.mounted){
        if (markersTimer == null || !markersTimer!.isActive) {
          return;
        }
        // Ensure user data is valid
        if (i.userData != null &&
            i.userData!.lat != null &&
            i.userData!.long != null &&
            i.userData!.lat != 0.0 &&
            i.userData!.long != 0.0) {
          var point = LatLng(i.userData!.lat!, i.userData!.long!);
          // distance = LocationUtil.calcDistance(
          //   startLatitude: point.latitude,
          //   startLongitude: point.longitude,
          //   endLatitude: position.latitude,
          //   endLongitude: position.longitude,
          // );
          // nurseBloc.add(AddNewNearbyNurseEvent(nurse: i, distance: distance));
          MarkerId markerId = MarkerId(
              "${i.userData!.isWomen == true ? "isWomen" : "isMan"}-${i.id}");
          Marker marker = Marker(
            markerId: markerId,
            position: point,
            onTap: () {},
            infoWindow: InfoWindow(
              title:
                  "${i.userData!.userName} ${ReviewModel.calcReviewStar(i.reviewList!)}",
              snippet: LocationUtil.getDistanceView(i.distanceKM, i.distanceM),
              onTap: () {
                NurseBloc.get(event.ctx).add(UpdateCurrentNurseEvent(nurse: i));
                if (event.ctx.mounted) {
                  Util.pushPage(const NurseDetails(), event.ctx);
                }
              },
            ),
            icon: showAllNurses
                ? await BitmapDescriptor.asset(
                    const ImageConfiguration(size: Size(40, 40)),
                    i.userData!.isWomen == true
                        ? "assets/images/nurse_test.png"
                        : "assets/images/avatar.png")
                : await LocationUtil.convertImageFileToCustomBitmapDescriptor(
                    i.userData!.image.toString()),
          );

          markersToAdd.add(marker);
          markers.addAll(
              {for (var marker in markersToAdd) marker.markerId: marker});
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
    } catch (e) {
      // Error handled silently
    }
  }
}
