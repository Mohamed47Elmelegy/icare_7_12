import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/booking/domain/use_cases/get_patient_details_usecase.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_state.dart';

class BookingNurseCubit extends Cubit<BookingNurseState> {
  final GetPatientDetailsUseCase getPatientDetailsUseCase;

  BookingNurseCubit({required this.getPatientDetailsUseCase})
      : super(BookingNurseInitial());

  static BookingNurseCubit get(context) => BlocProvider.of(context);

  // In-memory cache for patient data
  final Map<String, UserServiceModel> _patientCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  // Cache duration: 5 minutes
  static const _cacheDuration = Duration(minutes: 5);

  /// Get patient details with caching support
  ///
  /// [userId] - The patient's user ID
  /// [forceRefresh] - If true, bypass cache and fetch fresh data
  Future<void> getPatientDetails(String userId,
      {bool forceRefresh = false}) async {
    // Check if cached and not expired
    if (!forceRefresh && _patientCache.containsKey(userId)) {
      final timestamp = _cacheTimestamps[userId];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheDuration) {
        // Loading patient from cache

        emit(BookingNurseLoaded(_patientCache[userId]!));
        return;
      } else {
        // Cache expired, fetching fresh data

      }
    }

    // Fetch from API
    // Fetching patient details from API

    emit(BookingNurseLoading());
    final result = await getPatientDetailsUseCase(userId: userId);
    result.fold(
      (failure) => emit(BookingNurseError(failure.toString())),
      (data) {
        // Save to cache
        _patientCache[userId] = data;
        _cacheTimestamps[userId] = DateTime.now();
        // Cached patient data

        emit(BookingNurseLoaded(data));
      },
    );
  }

  /// Clear all cached patient data
  void clearCache() {
    _patientCache.clear();
    _cacheTimestamps.clear();
    // Cleared all patient cache

  }

  /// Clear cached data for a specific patient
  void clearPatientCache(String userId) {
    _patientCache.remove(userId);
    _cacheTimestamps.remove(userId);
    // Cleared cache for patient

  }

  /// Check if patient data is cached
  bool isCached(String userId) {
    return _patientCache.containsKey(userId);
  }

  /// Get cached patient data without triggering API call
  UserServiceModel? getCachedPatient(String userId) {
    return _patientCache[userId];
  }
}
