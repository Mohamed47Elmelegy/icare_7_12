// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/root_app/screens/welcome_screens/get_started.dart';
import 'package:icare/features/shared_widgets/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:upgrader/upgrader.dart';
import 'package:icare/core/coordinator/app_startup_coordinator.dart';
import 'package:icare/core/di/injection_core.dart';

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
    if (mounted) {
      _startApp();
    }
    super.didChangeDependencies();
  }

  Future<void> _startApp() async {
    final coordinator = sl<AppStartupCoordinator>();

    // Wait for brand visibility and init
    final results = await Future.wait([
      coordinator.initApp(),
      Future.delayed(const Duration(seconds: 3)),
      Upgrader.sharedInstance.initialize(),
    ]);

    final bool isInitSuccess = results[0] as bool;

    if (!mounted) return;

    if (isInitSuccess) {
      // User is verified and profile is loaded
      Util.pushPageAndRemoveRoutes(const RootScreen(), context);
    } else {
      // Guest or authentication failed/cleared
      if (Util.getUserType() != 'null' && Util.getUserType() != '') {
        Util.pushPageAndRemoveRoutes(const GetStartedScreen(), context);
        Util.pushPage(const LoginScreen(), context);
      } else {
        Util.pushPageAndRemoveRoutes(const GetStartedScreen(), context);
      }
    }
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
