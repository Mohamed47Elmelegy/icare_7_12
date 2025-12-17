import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/set_notification.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsUtils {
  static Future initialPushNotification() async {
    Permission.notification.request();

    /// for android and ios versions
    await Future.wait([
      Firebase.initializeApp(),
      SetNotification.setupFlutterNotifications()
    ]);
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void pushNotificationListener(BuildContext context) async {
    if (!Platform.isIOS) {
      if (Util.isCustomer())
        await FirebaseMessaging.instance.subscribeToTopic('patient');
      if (Util.isNurse())
        await FirebaseMessaging.instance.subscribeToTopic('nurses');
      if (Util.isAssistant())
        await FirebaseMessaging.instance.subscribeToTopic('assistant');
      if (!Util.checkUser())
        await FirebaseMessaging.instance.subscribeToTopic('discover_users');
    }

    FirebaseMessaging.onMessage.listen((event) {
      SetNotification.showFlutterNotification(
          RemoteMessage(notification: event.notification!));

      if (event.notification == null || event.notification!.body == null)
        return;
      checkNotification(context, event);
    }).onError((err) {
      debugPrint("FirebaseMessaging onMessage: $err");
    });
  }

  static checkNotification(context, RemoteMessage event) {
    try {
      if (event.notification!.body!.contains("request") ||
          event.notification!.body!.contains("حجز") ||
          event.notification!.body!.contains("الحجز")) {
        debugPrint("update all orders");
        BookingBloc.get(context).add(const FetchAllOrderEvent());
        AccountBloc.get(context).add(const FetchAllNotificationsEvent());
      }

      if (event.notification!.body!.contains("صلاحية") ||
          event.notification!.body!.contains("permission")) {
        debugPrint("access to edit patient profile");
        BookingBloc.get(context).add(const FetchAllOrderEvent());
        CustomDialogs.patientGiveAccessToEditProfile(context);
      }
    } catch (e) {
      debugPrint("checkNotification: $e");
    }
  }

  static getFcmToken() async {
    try {
      String? token = Platform.isIOS
          ? await FirebaseMessaging.instance.getAPNSToken()
          : await FirebaseMessaging.instance.getToken();
      debugPrint("FirebaseMessaging token: $token");
      return token ?? '';
    } catch (e) {
      debugPrint("getFcmToken: $e");
      return '';
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await SetNotification.setupFlutterNotifications();

  /// this line customized to comment for wordpress plugin only
  if (Platform.isIOS) SetNotification.showFlutterNotification(message);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

// if #available(iOS 10.0, *) {
// UNUserNotificationCenter.current().delegate = self
// let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
// UNUserNotificationCenter.current().requestAuthorization(
// options: authOptions,
// completionHandler: {_, _ in })
// } else {
// let settings: UIUserNotificationSettings =
// UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
// application.registerUserNotificationSettings(settings)
// }
// application.registerForRemoteNotifications()
