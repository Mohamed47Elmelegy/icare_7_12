import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/navigator_key.dart';
import 'package:icare/core/utils/set_notification.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
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

  static bool _isListenerSetup = false;

  static void pushNotificationListener() async {
    if (_isListenerSetup) return;
    _isListenerSetup = true;

    if (!Platform.isIOS) {
      if (Util.isCustomer()) {
        await FirebaseMessaging.instance.subscribeToTopic('patient');
      }
      if (Util.isNurse()) {
        await FirebaseMessaging.instance.subscribeToTopic('nurses');
      }
      if (Util.isAssistant()) {
        await FirebaseMessaging.instance.subscribeToTopic('assistant');
      }
      if (Util.isDoctor()) {
        await FirebaseMessaging.instance.subscribeToTopic('doctors');
      }
      if (!Util.checkUser()) {
        await FirebaseMessaging.instance.subscribeToTopic('discover_users');
      }
    }

    FirebaseMessaging.onMessage.listen((event) {
      // عرض الإشعار إذا كان موجود
      if (event.notification != null) {
        SetNotification.showFlutterNotification(
            RemoteMessage(notification: event.notification!));
      } else {
        // إذا لم يكن هناك notification payload، أنشئ واحد من البيانات
        debugPrint("📨 Received message without notification payload");
        debugPrint("📨 Data: ${event.data}");

        // عرض إشعار محلي باستخدام البيانات المتوفرة
        if (event.data.isNotEmpty) {
          String title = event.data['senderName'] ?? 'رسالة جديدة';
          String body = event.data['msg'] ?? event.data['message'] ?? '';

          SetNotification.showNotification(title: title, msg: body);
        }
      }

      if (event.notification == null || event.notification!.body == null) {
        // حتى لو مفيش notification، نفذ checkNotification للتحديثات
        if (event.data.isNotEmpty) {
          checkNotification(event);
        }
        return;
      }
      checkNotification(event);
    }).onError((err) {
      debugPrint("FirebaseMessaging onMessage: $err");
    });
  }

  static checkNotification(RemoteMessage event) {
    try {
      final context = navigatorKey.currentContext;
      if (context == null) {
        debugPrint("❌ checkNotification: Context is null");
        return;
      }

      // معالجة إشعارات الحجز
      if (event.notification!.body!.contains("request") ||
          event.notification!.body!.contains("حجز") ||
          event.notification!.body!.contains("الحجز")) {
        debugPrint("update all orders");
        BookingBloc.get(context).add(const FetchAllOrderEvent());
        AccountBloc.get(context).add(const FetchAllNotificationsEvent());
      }

      // ✨ معالجة إشعارات الدردشة
      if (event.data['type'] == 'chat' ||
          event.notification!.body!.contains("رسالة") ||
          event.notification!.title!.contains("رسالة")) {
        debugPrint("📨 Chat notification received");
        debugPrint("💬 Message: ${event.data['message']}");
        debugPrint("👤 Sender: ${event.data['senderName']}");
        debugPrint("🏠 Room ID: ${event.data['roomID']}");

        //  يمكن إضافة تحديث قائمة الدردشات هنا إذا لزم الأمر
      }

      // if (event.notification!.body!.contains("صلاحية") ||
      //     event.notification!.body!.contains("permission")) {
      //   debugPrint("access to edit patient profile");
      //   BookingBloc.get(context).add(const FetchAllOrderEvent());
      //   CustomDialogs.patientGiveAccessToEditProfile(context);
      // }
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
  debugPrint('📨 Handling a background message ${message.messageId}');
  debugPrint('📨 Notification type: ${message.data['type']}');

  // معالجة إشعارات الدردشة في الخلفية
  if (message.data['type'] == 'chat') {
    debugPrint('💬 Chat message in background: ${message.data['message']}');
    debugPrint('👤 From: ${message.data['senderName']}');
  }
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
