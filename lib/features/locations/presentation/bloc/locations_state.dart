import 'package:flutter/material.dart';

@immutable
abstract class LocationsState {
  const LocationsState();
}

class LocationsInitialState extends LocationsState {}

class LocationsSuccessfullyState extends LocationsState {
  const LocationsSuccessfullyState();
}

class UpdateCurrentLocationSuccessfullyState extends LocationsState {
  const UpdateCurrentLocationSuccessfullyState();
}

class LocationsFailedState extends LocationsState {
  const LocationsFailedState();
}

class LocationsLoadingState extends LocationsState {
  const LocationsLoadingState();
}
