import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/use_cases/search_by_service_usecase.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchByServiceUseCase searchByServiceUseCase;

  // Current filter state - default to 'nurse'
  String? selectedProviderType = UserEnum.NURSE.name.toLowerCase();
  List<ServicesModel> selectedServices = [];
  double? currentLatitude;
  double? currentLongitude;

  SearchBloc({required this.searchByServiceUseCase})
      : super(ProviderTypeSelectedState(providerType: UserEnum.NURSE.name.toLowerCase())) {
    on<SelectProviderTypeEvent>(_onSelectProviderType);
    on<SelectServiceEvent>(_onSelectService);
    on<SearchByFiltersEvent>(_onSearchByFilters);
    on<ClearSearchFiltersEvent>(_onClearFilters);
    on<LoadServicesForProviderEvent>(_onLoadServicesForProvider);
    on<UpdateLocationEvent>(_onUpdateLocation);
  }

  void _onSelectProviderType(
      SelectProviderTypeEvent event, Emitter<SearchState> emit) {
    debugPrint("🔄 Provider Type Changed:");
    debugPrint("   └─ From: $selectedProviderType");
    debugPrint("   └─ To: ${event.providerType}");

    selectedProviderType = event.providerType;
    selectedServices = []; // Clear services when provider type changes

    debugPrint("   └─ Selected services cleared");

    emit(ProviderTypeSelectedState(providerType: event.providerType));
    // Trigger loading services for the new provider type
    add(LoadServicesForProviderEvent(providerType: event.providerType));
  }

  void _onSelectService(SelectServiceEvent event, Emitter<SearchState> emit) {
    debugPrint("📋 Services Selection Changed:");
    debugPrint("   └─ Selected Services Count: ${event.services.length}");
    if (event.services.isNotEmpty) {
      debugPrint("   └─ Selected Services:");
      for (var service in event.services) {
        debugPrint(
            "      • ${service.name ?? service.value} (ID: ${service.id})");
      }
    }

    selectedServices = event.services;
    emit(ServicesSelectedState(
        serviceIds: event.services.map((s) => s.id).toList()));
  }

  Future<void> _onSearchByFilters(
      SearchByFiltersEvent event, Emitter<SearchState> emit) async {
    debugPrint("🔍 Starting Search with Filters:");
    debugPrint("   └─ User Type: ${event.filters.userType}");
    debugPrint("   └─ Service IDs: ${event.filters.serviceIds}");
    debugPrint("   └─ Latitude: ${event.filters.latitude}");
    debugPrint("   └─ Longitude: ${event.filters.longitude}");
    if (event.filters.searchRadius != null) {
      debugPrint("   └─ Custom Max Radius: ${event.filters.searchRadius}km");
    } else {
      debugPrint("   └─ Max Radius: 20km (sorted by distance, nearest first)");
    }

    emit(SearchLoadingState());

    // Update current location
    if (event.filters.latitude != null) {
      currentLatitude = event.filters.latitude;
    }
    if (event.filters.longitude != null) {
      currentLongitude = event.filters.longitude;
    }

    final result = await searchByServiceUseCase.call(filters: event.filters);

    result.fold(
      (failure) {
        debugPrint("❌ Search Failed: $failure");
        emit(const SearchErrorState(message: 'Failed to search'));
      },
      (results) {
        debugPrint("✅ Search Successful: ${results.length} results found");
        if (results.isNotEmpty && event.filters.latitude != null) {
          debugPrint("   └─ Results sorted by distance (nearest to farthest)");
        }
        emit(SearchSuccessState(results: results));
      },
    );
  }

  void _onClearFilters(
      ClearSearchFiltersEvent event, Emitter<SearchState> emit) {
    selectedProviderType = 'nurse'; // Reset to default 'nurse'
    selectedServices = [];
    emit(const ProviderTypeSelectedState(providerType: 'nurse'));
  }

  void _onLoadServicesForProvider(
      LoadServicesForProviderEvent event, Emitter<SearchState> emit) {
    // This event is handled by filtering services in the UI
    // based on the selected provider type
    emit(ProviderTypeSelectedState(providerType: event.providerType));
  }

  void _onUpdateLocation(UpdateLocationEvent event, Emitter<SearchState> emit) {
    debugPrint("📍 Location Updated:");
    debugPrint("   └─ Latitude: ${event.latitude}");
    debugPrint("   └─ Longitude: ${event.longitude}");

    currentLatitude = event.latitude;
    currentLongitude = event.longitude;

    // No need to emit new state, just update internal location
  }

  // Helper method to get current filters
  SearchFilterEntity getCurrentFilters() {
    return SearchFilterEntity(
      userType: selectedProviderType,
      serviceIds: selectedServices.map((s) => s.id).toList(),
      latitude: currentLatitude,
      longitude: currentLongitude,
      searchRadius: null, // null = use progressive radius expansion
    );
  }

  // Static method to get bloc from context
  static SearchBloc get(context) => BlocProvider.of(context);
}
