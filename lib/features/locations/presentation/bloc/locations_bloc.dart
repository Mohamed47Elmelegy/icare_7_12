import 'dart:convert';

import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/data/models/location_model.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/locations/domain/use_cases/locations_usecase.dart';
import 'package:icare/features/locations/presentation/bloc/locations_event.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  /// addresses section
  FetchUserLocationsUseCase fetchUserLocationsUseCase;
  UpdateLocationUseCase updateLocationUseCase;
  RemoveLocationUseCase removeLocationUseCase;
  AddLocationUseCase addLocationUseCase;
  AddressEntity? userLocationsList;
  LocationEntity? billingAddress;
  LocationEntity? shippingAddress;
  List<LocationEntity> localUserLocationsList = [];

  static LocationsBloc get(BuildContext context) => BlocProvider.of(context);

  LocationsBloc(
      {required this.addLocationUseCase,
      required this.removeLocationUseCase,
      required this.updateLocationUseCase,
      required this.fetchUserLocationsUseCase})
      : super(LocationsInitialState()) {
    on<UpdateCurrentLocationEvent>((event, emit) async {
      await updateCurrentCheckOutLocation(event, emit);
    });

    on<FetchUserLocationsEvent>((event, emit) async {
      await getUserLocationsData(event, emit);
    });

    on<AddLocationEvent>((event, emit) async {
      await addNewLocationsData(event, emit);
      await getUserLocationsData(event, emit);
    });

    on<AddLocalLocationEvent>((event, emit) {
      addLocalLocation(event, emit);
    });

    on<UpdateLocationEvent>((event, emit) async {
      await updateLocationsData(event, emit);
      await getUserLocationsData(event, emit);
    });

    on<RemoveLocationEvent>((event, emit) async {
      await removeLocationsData(event, emit);
      await getUserLocationsData(event, emit);
    });
  }

  LocationEntity? currentCheckOutLocation;
  String? city;
  String? governorate;
  updateCurrentCheckOutLocation(UpdateCurrentLocationEvent event, emit) {
    emit(const LocationsLoadingState());
    if (event.location != null) currentCheckOutLocation = event.location;
    if (event.city != null) city = event.city;
    if (event.governorate != null) governorate = event.governorate;
    emit(const UpdateCurrentLocationSuccessfullyState());
  }

  getUserLocationsData(event, emit) async {
    try {
      if (!Util.checkUser()) return;
      emit(const LocationsLoadingState());
      var res = await fetchUserLocationsUseCase();
      res.fold((l) {
        emit(const LocationsFailedState());
      }, (data) {
        userLocationsList = data;
        if (userLocationsList!.billingAddress != null) {
          billingAddress = userLocationsList!.billingAddress;
        }
        if (userLocationsList!.shippingAddress != null) {
          shippingAddress = userLocationsList!.shippingAddress;
        }
        currentCheckOutLocation = null;
        localUserLocationsList = _getLocalLocations();
        emit(const LocationsSuccessfullyState());
      });
    } catch (e) {
      emit(const LocationsFailedState());
    }
  }

  List<LocationEntity> _getLocalLocations() {
    if (!SharedPref().containPreference(Constants.allLocalLocationsList)) {
      return [];
    }
    String data =
        SharedPref().getPreferenceString(Constants.allLocalLocationsList);
    List<dynamic> decodedList = json.decode(data);
    List<LocationEntity> locationList = decodedList
        .map((location) => LocationModel.fromJsonLocal(location, "local"))
        .toList();
    return locationList;
  }

  addLocalLocation(AddLocalLocationEvent event, emit) {
    SharedPref().removePreference(Constants.allLocalLocationsList);
    emit(const LocationsLoadingState());
    if (event.isUpdate == true) {
      if (clearLocalLocation(setLocationData(event.data))) {
        localUserLocationsList.add(setLocationData(event.data));
      }
    } else {
      localUserLocationsList.add(setLocationData(event.data));
    }
    String encodedList = json.encode(localUserLocationsList
        .map((location) => LocationModel.toJsonLocal(location, "local"))
        .toList());
    SharedPref()
        .setPreferencesString(Constants.allLocalLocationsList, encodedList);
    localUserLocationsList = _getLocalLocations();
    emit(const LocationsSuccessfullyState());
  }

  setLocationData(Map<String, dynamic> data) {
    String kind = "local";
    return LocationModel(
      address1: data['${kind}_address_1'] ?? "",
      address2: data['${kind}_address_2'] ?? "",
      country: data['${kind}_country'] ?? "",
      phone: data['${kind}_phone'] ?? "",
      id: int.parse(DateTime.now().millisecond.toString() +
          DateTime.now().minute.toString() +
          DateTime.now().day.toString()),
      type: data[kind] ?? "",
      long: 0.0,
      lat: 0.0,
      state: data['${kind}_state'] ?? "",
      firstName: data['${kind}_first_name'] ?? "",
      lastName: data['${kind}_last_name'] ?? "",
      email: data['${kind}_email'] ?? "",
      postCode: data['${kind}_postcode'] ?? "",
      locationType: data['location_type'] ?? "",
    );
  }

  bool clearLocalLocation(LocationEntity location) {
    int index = localUserLocationsList
        .indexWhere((element) => element.id == location.id);
    if (index != -1) {
      localUserLocationsList.removeAt(index);
      return true;
    }
    return false;
  }

  addNewLocationsData(event, emit) async {
    try {
      emit(const LocationsLoadingState());
      var res = await addLocationUseCase(data: event.data);
      res.fold((l) {
        emit(const LocationsFailedState());
      }, (res) {
        if (res) {
          emit(const LocationsSuccessfullyState());
        } else {
          emit(const LocationsFailedState());
        }
      });
    } catch (e) {
      emit(const LocationsFailedState());
    }
  }

  updateLocationsData(event, emit) async {
    try {
      emit(const LocationsLoadingState());
      var res = await updateLocationUseCase(data: event.data);
      res.fold((l) {
        emit(const LocationsFailedState());
      }, (res) {
        if (res) {
          emit(const LocationsSuccessfullyState());
        } else {
          emit(const LocationsFailedState());
        }
      });
    } catch (e) {
      emit(const LocationsFailedState());
    }
  }

  removeLocationsData(event, emit) async {
    try {
      emit(const LocationsLoadingState());
      var res = await removeLocationUseCase(addressId: event.id);
      res.fold((l) {
        emit(const LocationsFailedState());
      }, (res) {
        if (res) {
          emit(const LocationsSuccessfullyState());
        } else {
          emit(const LocationsFailedState());
        }
      });
    } catch (e) {
      emit(const LocationsFailedState());
    }
  }

  bool checkIFAddressEmpty(LocationEntity item) {
    if (item.phone.isEmpty && item.country.isEmpty && item.phone.isEmpty) {
      return true;
    }
    return false;
  }
}
