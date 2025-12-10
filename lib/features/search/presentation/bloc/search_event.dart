import 'package:equatable/equatable.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SelectProviderTypeEvent extends SearchEvent {
  final String providerType; // 'nurse', 'assistant', 'doctor'

  const SelectProviderTypeEvent({required this.providerType});

  @override
  List<Object?> get props => [providerType];
}

class SelectServiceEvent extends SearchEvent {
  final List<ServicesModel> services;

  const SelectServiceEvent({required this.services});

  @override
  List<Object?> get props => [services];
}

class SearchByFiltersEvent extends SearchEvent {
  final SearchFilterEntity filters;

  const SearchByFiltersEvent({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class ClearSearchFiltersEvent extends SearchEvent {
  const ClearSearchFiltersEvent();
}

class LoadServicesForProviderEvent extends SearchEvent {
  final String providerType;

  const LoadServicesForProviderEvent({required this.providerType});

  @override
  List<Object?> get props => [providerType];
}

class UpdateLocationEvent extends SearchEvent {
  final double latitude;
  final double longitude;

  const UpdateLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
