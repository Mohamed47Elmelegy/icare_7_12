import 'package:icare/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/use_cases/search_by_service_usecase.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchByServiceUseCase searchByServiceUseCase;

  // Current filter state - NO DEFAULT, user must select
  String? selectedProviderType; // Changed from default 'nurse' to null
  List<ServicesModel> selectedServices = [];
  double? currentLatitude;
  double? currentLongitude;

  SearchBloc({required this.searchByServiceUseCase})
      : super(SearchInitialState()) {
    // Changed from ProviderTypeSelectedState
    on<SelectProviderTypeEvent>(_onSelectProviderType);
    on<SelectServiceEvent>(_onSelectService);
    on<SearchByFiltersEvent>(_onSearchByFilters);
    on<ClearSearchFiltersEvent>(_onClearFilters);
    on<LoadServicesForProviderEvent>(_onLoadServicesForProvider);
    on<UpdateLocationEvent>(_onUpdateLocation);
  }

  void _onSelectProviderType(
      SelectProviderTypeEvent event, Emitter<SearchState> emit) {
    AppLogger.d("🔄 Provider Type Changed:");
    AppLogger.d("   └─ From: $selectedProviderType");
    AppLogger.d("   └─ To: ${event.providerType}");

    selectedProviderType = event.providerType;
    selectedServices = []; // Clear services when provider type changes

    AppLogger.d("   └─ Selected services cleared");

    emit(ProviderTypeSelectedState(providerType: event.providerType));
    // Trigger loading services for the new provider type
    add(LoadServicesForProviderEvent(providerType: event.providerType));
  }

  void _onSelectService(SelectServiceEvent event, Emitter<SearchState> emit) {
    AppLogger.d("📋 Services Selection Changed:");
    AppLogger.d("   └─ Selected Services Count: ${event.services.length}");
    if (event.services.isNotEmpty) {
      AppLogger.d("   └─ Selected Services:");
      for (var service in event.services) {
        AppLogger.d(
            "      • ${service.name ?? service.value} (ID: ${service.id})");
      }
    }

    selectedServices = event.services;
    emit(ServicesSelectedState(
        serviceIds: event.services.map((s) => s.id).toList()));
  }

  Future<void> _onSearchByFilters(
      SearchByFiltersEvent event, Emitter<SearchState> emit) async {
    AppLogger.d("🔍 Starting Search with Filters:");
    AppLogger.d("   └─ User Type: ${event.filters.userType}");
    AppLogger.d("   └─ Service IDs: ${event.filters.serviceIds}");
    AppLogger.d("   └─ Latitude: ${event.filters.latitude}");
    AppLogger.d("   └─ Longitude: ${event.filters.longitude}");
    if (event.filters.searchRadius != null) {
      AppLogger.d("   └─ Custom Max Radius: ${event.filters.searchRadius}km");
    } else {
      AppLogger.d("   └─ Max Radius: 20km (sorted by distance, nearest first)");
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
        AppLogger.e("❌ Search Failed: $failure");
        emit(const SearchErrorState(message: 'Failed to search'));
      },
      (results) {
        AppLogger.d("✅ Search Successful: ${results.length} results found");
        if (results.isNotEmpty && event.filters.latitude != null) {
          AppLogger.d("   └─ Results sorted by distance (nearest to farthest)");
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
    AppLogger.d("📍 Location Updated:");
    AppLogger.d("   └─ Latitude: ${event.latitude}");
    AppLogger.d("   └─ Longitude: ${event.longitude}");

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
