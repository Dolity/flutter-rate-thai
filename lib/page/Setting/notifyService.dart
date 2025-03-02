import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testprojectbc/main.dart';

class NotificationService {
  // static Future<void> initialize(
  //   FlutterLocalNotificationsPlugin notificationsPlugin,
  // ) async {
  //   var androidInitialize = AndroidInitializationSettings('app_icon');
  //   var initializationSettings =
  //       InitializationSettings(android: androidInitialize);
  //   await notificationsPlugin.initialize(
  //     initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //       try {
  //         if (payload != null) {
  //           print('Notification payload: $payload');
  //         }
  //       } catch (e) {}
  //     },
  //   );
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('FCM onMessage: $message');
  //     showNotification(notificationsPlugin, message.notification?.title,
  //         message.notification?.body, message.data['type'], message.data['id']);
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('FCM onMessageOpenedApp: $message');
  //     showNotification(notificationsPlugin, message.notification?.title,
  //         message.notification?.body, message.data['type'], message.data['id']);
  //   });
  // }

//   static Future<void> showForegroundNotification(
//     FlutterLocalNotificationsPlugin notificationsPlugin,
//     String title,
//     String body,
//   ) async {
//     var androidDetails = AndroidNotificationDetails(
//       'foreground_channel',
//       'Foreground Channel',
//       'Channel for foreground notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var notificationDetails = NotificationDetails(android: androidDetails);
//     await notificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: 'foreground_notification',
//     );
//   }
}

  // static void init() {
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  //     iOS: IOSInitializationSettings(),
  //   );

  //   _notificationsPlugin = FlutterLocalNotificationsPlugin();
  //   _notificationsPlugin.initialize(initializationSettings);
  // }

  // static Future<void> showNotification({
  //   String title,
  //   String body,
  // }) async {
  //   final AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'channelId',
  //     'channelName',
  //     'channelDescription',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   final NotificationDetails platformDetails =
  //       NotificationDetails(android: androidDetails);

  //   await _notificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     platformDetails,
  //   );
  // }

