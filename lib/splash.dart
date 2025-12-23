// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/root_app/screens/welcome_screens/get_started.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _checkInternet() async {
    if (await Util.isConnected() == false) {
      if (mounted) {
        Util.pushPageAndRemoveRoutes(const NoConnectionScreen(), context);
      }
      return;
    }
  }

  @override
  void didChangeDependencies() {
    _checkInternet();
    if (mounted) Util.getAllUserAppData(context: context, isSplash: true);
    Timer(const Duration(seconds: 4), () async {
      await LocationUtil.checkLocationPermission();
      await NotificationsUtils.initialPushNotification();
      await CustomDialogs.acceptLocationPermission(context);
      await Upgrader.sharedInstance.initialize();
      // if(Upgrader.sharedInstance.isUpdateAvailable()){
      //   if(mounted) return Util.pushPageAndRemoveRoutes(const UpdateAppScreen(), context);
      // }

      if (Util.checkUser()) {
        // Check verification status for professionals
        bool isVerified = await Util.checkUserVerificationStatus(context);
        if (!isVerified) {
          // User is pending approval, redirect to login
          debugPrint("⚠️ User pending approval, redirecting to login");
          if (mounted) {
            Util.pushPageAndRemoveRoutes(const GetStartedScreen(), context);
            Util.pushPage(const LoginScreen(), context);
          }
          return;
        }
        // User is verified or is a customer, proceed to home
        if (mounted) Util.pushPageAndRemoveRoutes(const RootScreen(), context);
      } else {
        if (Util.getUserType() != 'null' && Util.getUserType() != '') {
          Util.pushPageAndRemoveRoutes(const GetStartedScreen(), context);
          Util.pushPage(const LoginScreen(), context);
          return;
        }
        if (mounted) {
          Util.pushPageAndRemoveRoutes(const GetStartedScreen(), context);
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset(
        AppImages.logo,
      ),
    );
  }
}
