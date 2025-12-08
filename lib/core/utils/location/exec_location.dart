import 'dart:developer';

// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/settings/android_settings.dart';
// import 'package:background_locator/settings/ios_settings.dart';
// import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/location/location_callback_handler.dart';
import 'package:permission_handler/permission_handler.dart';

void onStartTrack() async {
  try{
    if (await checkLocationPermission()) {
      _startLocator();
      // await BackgroundLocator.isServiceRunning();
    } else {
      // show error
    }
  }catch(e){
    debugPrint("on start $e");
  }
}

void onStopTrack()async{
  try{
    // await BackgroundLocator.unRegisterLocationUpdate();
  }catch(e){
    debugPrint("onStopTrack $e");
  }
}

Future<bool> checkLocationPermission() async {
  return await Permission.location.isGranted;
}

void _startLocator() {
  Map<String, dynamic> data = {'countInit': 1};
  try{
    // BackgroundLocator.registerLocationUpdate(
    //     LocationCallbackHandler.callback,
    //     initCallback: LocationCallbackHandler.initCallback,
    //     initDataCallback: data,
    //     disposeCallback: LocationCallbackHandler.disposeCallback,
    //     iosSettings: const IOSSettings(
    //         accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 1),
    //     autoStop: false,
    //     androidSettings: const AndroidSettings(
    //         accuracy: LocationAccuracy.NAVIGATION,
    //         interval: 60,
    //         distanceFilter: 0,
    //         client: LocationClient.google,
    //         wakeLockTime: 120,
    //         androidNotificationSettings:  AndroidNotificationSettings(
    //             notificationChannelName: 'Location tracking',
    //             notificationTitle: '',
    //             notificationMsg: '',
    //             notificationBigMsg: 'Start booking location Tracking - تتبع الموقع لتحديث موقع الحجز',
    //             notificationIconColor: Colors.grey,
    //             notificationIcon: 'ic_launcher',
    //             notificationTapCallback:
    //             LocationCallbackHandler.notificationCallback))).catchError((e){
    //                    debugPrint("e $e");
    //               }).onError((error, stackTrace) {
    //                    debugPrint("d $error");
    //               });
  }catch(e){
    log("_startLocator: $e");
  }
}