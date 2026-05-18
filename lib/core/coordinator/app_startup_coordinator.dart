import 'dart:async';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icare/core/network/token_storage_helper.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/constants/constant.dart';
import 'package:geolocator/geolocator.dart';

class AppStartupCoordinator {
  final AccountBloc accountBloc;
  final RootBloc rootBloc;
  final ServicesBloc servicesBloc;

  AppStartupCoordinator({
    required this.accountBloc,
    required this.rootBloc,
    required this.servicesBloc,
  });

  /// Initialize all essential app data before navigation from Splash
  Future<bool> initApp() async {
    try {
      // 1. Initial State Sync
      rootBloc.add(const FetchSettingEvent());

      // 2. Auth Check
      final bool hasToken = await TokenStorageHelper.hasToken();

      if (!hasToken) {
        return false;
      }

      // 3. User Persistence Check
      // ignore: unused_local_variable
      final String userId = SharedPref().getPreferenceString(Constants.userId);

      // 4. Fetch User Profile
      accountBloc.add(const FetchProfileDataEvent());

      // Wait for profile success ONLY if not already loaded
      bool profileLoaded = accountBloc.state is FetchProfileDataState &&
          (accountBloc.state as FetchProfileDataState).response.isSuccess ==
              true;

      if (!profileLoaded) {
        try {
          await accountBloc.stream
              .firstWhere((state) =>
                  state is FetchProfileDataState &&
                  state.response.isSuccess == true)
              .timeout(const Duration(seconds: 10));
        } catch (e) {
          await SharedPref().clearPreferences();
          await TokenStorageHelper.deleteToken();
          return false;
        }
      }

      // 5. Fetch Services/Specialties AFTER profile or fallback is ready
      String? userType =
          accountBloc.currentUser?.userType ?? Util.getUserType();

      servicesBloc.add(FetchAllServicesEvent(userType: userType));

      // 6. Update Location and Token in background
      _updateLocationAndToken();

      // 7. Check Verification Status for Professionals
      bool isVerified = _checkUserVerificationStatusSync();
      if (!isVerified) {
        return false;
      }

      // 8. Initialize background services
      unawaited(NotificationsUtils.initialPushNotification());
      unawaited(LocationUtil.checkLocationPermission());

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check verification status using cached currentUser data
  bool _checkUserVerificationStatusSync() {
    try {
      // Customers don't need verification
      if (Util.isCustomer()) {
        return true;
      }

      final user = accountBloc.currentUser;
      if (user == null) {
        return false;
      }


      int? verificationStatus;

      if (Util.isNurse() || Util.isAssistant()) {
        verificationStatus = user.nurse?.verificationStatus;
      } else if (Util.isDoctor()) {
        verificationStatus = user.doctor?.verificationStatus;
      }

      if (verificationStatus == 0) {
        SharedPref().clearPreferences();
        return false;
      }

      return true;
    } catch (e) {
      SharedPref().clearPreferences();
      return false;
    }
  }

  /// Internal helper to update location and token without UI context dependency where possible
  Future<void> _updateLocationAndToken() async {
    try {
      bool locationEnabled = await Permission.location.serviceStatus.isEnabled;
      Position? position;

      if (locationEnabled) {
        var status = await Permission.location.status;
        if (status.isGranted) {
          position = await Geolocator.getCurrentPosition(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.high));
        }
      }

      String? fcmToken = await Util.setToken();

      var userData = {
        'profile': '',
        'remember_token': fcmToken,
        if (position != null) 'latitude': position.latitude.toString(),
        if (position != null) 'longitude': position.longitude.toString(),
      };

      accountBloc.add(UpdateProfileEvent(user: userData));
    } catch (e) {
      // Location/Token update failed
    }
  }
}
