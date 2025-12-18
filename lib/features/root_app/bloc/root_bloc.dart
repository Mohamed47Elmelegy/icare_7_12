import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:icare/features/setting/data/models/city_model.dart';
import 'root_event.dart';
import 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  int currentScreenIndex = 2;
  String currentScreenTitle = translate("home.home");
  static RootBloc get(BuildContext context) => BlocProvider.of(context);
  RootBloc() : super(RootInitialState()) {
    on<ChangeIndex>((event, emit) {
      currentScreenIndex = event.index;
      currentScreenTitle = event.title;
      emit(RootSuccessState());
    });

    on<ChangeCurrentCurrency>((event, emit) {
      changeCurrentCurrency(event, emit);
    });

    on<ShowDrawerMenuEvent>((event, emit) async {
      showDrawerMenu(event, emit);
    });

    on<FetchSettingEvent>((event, emit) async {
      await getAllSetting(event, emit);
    });

    on<SearchEvent>((event, emit) async {
      search(event, emit);
    });

    on<ChooseCurrentAreaEvent>((event, emit) async {
      selectCurrentArea(event, emit);
    });
  }

  bool drawerMenuEnabled = false;
  showDrawerMenu(ShowDrawerMenuEvent event, emit) {
    emit(RootLoadingState());
    drawerMenuEnabled = !drawerMenuEnabled;
    emit(RootSuccessState());
  }

  changeCurrentCurrency(event, emit) {
    emit(RootSuccessState());
  }

  getAllSetting(event, emit) async {
    emit(RootLoadingState());
    await getAppData();
    // await getLocations();
    emit(RootSuccessState());
  }

  /// our locations
  List<LocationModel> ourLocations = [];
  getLocations() async {
    try {
      // ourLocations = await SettingsRemoteDataSource.getOurLocations();
    } catch (e) {
      debugPrint("getLocationsRootBloc: $e");
    }
  }

  /// get cities and governorates
  List<CityModel> citiesList = [];
  List<CityModel> governoratesList = [];
  getAppData() async {
    try {
      citiesList = await SettingsRemoteDataSource.fetchAllCities();
      governoratesList = await SettingsRemoteDataSource.fetchAllGovernorates();
    } catch (e) {
      debugPrint("getAppDataRootBloc: $e");
    }
  }

  late GoogleMapController mapController;

  List<CityModel?> currentAreaList = [];
  search(SearchEvent event, emit) {
    if (event.word.trim().isEmpty) {
      currentAreaList.clear();
      emit(RootSuccessState());
      return;
    }
    currentAreaList.clear();
    emit(RootLoadingState());
    currentAreaList.addAll(governoratesList
        .where((element) => element.title.contains(event.word.toString()))
        .toList());
    currentAreaList.addAll(citiesList
        .where((element) => element.title.contains(event.word.toString()))
        .toList());
    emit(RootSuccessState());
  }

  CityModel? currentArea;
  selectCurrentArea(ChooseCurrentAreaEvent event, emit) {
    emit(RootLoadingState());
    if (event.area != null) {
      currentArea = event.area;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(currentArea!.latitude, currentArea!.longitude), 14));
    } else {
      currentArea = null;
    }
    currentAreaList.clear();
    emit(RootSuccessState());
  }
}
