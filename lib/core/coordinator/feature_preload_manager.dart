import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';

class FeaturePreloadManager {
  final DoctorBloc doctorBloc;
  final NurseBloc nurseBloc;
  final BookingBloc bookingBloc;
  final CategoriesBloc categoriesBloc;
  final AccountBloc accountBloc;
  final ServicesBloc servicesBloc;

  // Track pending requests to avoid duplicate fires before state updates
  final Set<String> _pendingRequests = {};

  FeaturePreloadManager({
    required this.doctorBloc,
    required this.nurseBloc,
    required this.bookingBloc,
    required this.categoriesBloc,
    required this.accountBloc,
    required this.servicesBloc,
  });

  /// Helper to check and mark a request as pending
  bool _shouldTrigger(String key, bool condition) {
    if (condition && !_pendingRequests.contains(key)) {
      _pendingRequests.add(key);
      // Clean up after a delay or when state changes (simplified here with delay)
      Future.delayed(
          const Duration(seconds: 5), () => _pendingRequests.remove(key));
      return true;
    }
    return false;
  }

  /// Preload data for the Home screen (Publications)
  void preloadHomeData() {
    if (_shouldTrigger(
        'home_publications',
        categoriesBloc.publicationsList.isEmpty &&
            categoriesBloc.state is! FetchPublicationsLoadingState)) {
      // Preloading Publications
      categoriesBloc.add(const FetchAllPublicationsEvent());
    }
  }

  /// Preload data for Search/Specialists (Doctors and Nurses)
  void preloadSearchData() {
    // Doctors
    if (_shouldTrigger(
        'search_doctors',
        doctorBloc.doctorsList.isEmpty &&
            doctorBloc.state is! FetchAllDoctorsLoadingState)) {
      // Preloading Doctors
      doctorBloc.add(const FetchAllDoctorEvent());
    }

    // Nurses
    if (_shouldTrigger(
        'search_nurses',
        nurseBloc.nursesList.isEmpty &&
            nurseBloc.state is! FetchAllNursesLoadingState)) {
      // Preloading Nurses
      nurseBloc.add(const FetchAllNurseEvent());
    }

    // Ongoing Bookings (to filter search results)
    preloadOngoingBookings();
  }

  /// Preload ongoing bookings to filter specialists in search
  void preloadOngoingBookings() {
    if (_shouldTrigger(
        'ongoing_bookings',
        bookingBloc.ongoingBookingsList.isEmpty &&
            bookingBloc.state is! OrderLoadingState)) {
      // Preloading Ongoing Bookings
      bookingBloc.add(const GetOngoingBookingsEvent());
    }
  }

  /// Preload data for Orders/Appointments
  void preloadOrdersData() {
    if (_shouldTrigger(
        'orders_data',
        bookingBloc.bookingList.isEmpty &&
            bookingBloc.state is! OrderLoadingState)) {
      // Preloading Orders
      bookingBloc.add(const FetchAllOrderEvent());
    }
  }

  /// Preload Allergies (used in profile/registration)
  void preloadAllergies() {
    if (_shouldTrigger(
        'allergies_data',
        categoriesBloc.allAllergies.isEmpty &&
            categoriesBloc.state is! FetchCategoriesLoadingState)) {
      // Preloading Allergies
      categoriesBloc.add(const FetchAllAllergiesEvent());
    }
  }

  /// Preload Notifications
  void preloadNotifications() {
    if (_shouldTrigger(
        'notifications_data',
        servicesBloc.notificationList.isEmpty &&
            servicesBloc.state is! NotificationsLoading)) {
      // Preloading Notifications
      servicesBloc.add(const FetchAllNotificationsEvent());
    }
  }

  /// Main entry point for preloading based on route index or name
  void preloadForIndex(int index, bool isProfessional) {
    if (isProfessional) {
      switch (index) {
        case 1:
          preloadHomeData();
          break;
        case 2:
          preloadAllergies();
          break;
        case 3:
          preloadOrdersData();
          break;
      }
    } else {
      switch (index) {
        case 1:
          preloadSearchData();
          break;
        case 2:
          preloadHomeData();
          break;
        case 3:
          preloadAllergies();
          break;
        case 4:
          preloadOrdersData();
          break;
      }
    }
  }
}
