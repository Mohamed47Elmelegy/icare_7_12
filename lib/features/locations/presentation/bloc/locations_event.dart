import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LocationsEvent {
  const LocationsEvent();
}

class FetchUserLocationsEvent extends LocationsEvent {
  const FetchUserLocationsEvent();
}

class RemoveLocationEvent extends LocationsEvent {
  final int id;
  const RemoveLocationEvent({required this.id});
}

class UpdateLocationEvent extends LocationsEvent {
  final Map<String, dynamic> data;
  const UpdateLocationEvent({required this.data});
}

class AddLocationEvent extends LocationsEvent {
  final Map<String, dynamic> data;
  const AddLocationEvent({required this.data});
}

class AddLocalLocationEvent extends LocationsEvent {
  final Map<String, dynamic> data;
  final bool? isUpdate;
  const AddLocalLocationEvent({required this.data, this.isUpdate});
}

class UpdateCurrentLocationEvent extends LocationsEvent {
  final LocationEntity? location;
  final String? governorate;
  final String? city;
  const UpdateCurrentLocationEvent(
      {this.location, this.city, this.governorate});
}
