import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMNotificationTestPage extends StatefulWidget {
  @override
  _FCMNotificationTestPageState createState() =>
      _FCMNotificationTestPageState();
}

class _FCMNotificationTestPageState extends State<FCMNotificationTestPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _requestFirebaseMessagingPermission();
    _registerFirebaseMessagingToken();
    _requestFirebaseMessagingForeground();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print('FCM onMessage: $message');
        showNotificationSnackbar(
            message.notification?.title, message.notification?.body);

        // กำหนดการตั้งค่าและเริ่มต้นใช้งาน awesome_notifications
        AwesomeNotifications().initialize(
          null,
          [
            NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic Channel',
              channelDescription: 'Basic Notifications',
              defaultColor: Colors.teal,
              ledColor: Colors.teal,
              importance: NotificationImportance.High,
              playSound: true,
              enableVibration: true,
            ),
          ],
        );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('FCM onMessageOpenedApp: $message');
      showNotificationSnackbar(
          message.notification?.title, message.notification?.body);
    });
  }

  void _requestFirebaseMessagingPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        // _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  void showNotificationSnackbar(String? title, String? body) {
    if (title != null && body != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: title,
          body: body,
        ),
      );
    }
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  void sendApprovalNotificationToUser(String fcmToken) {
    // สร้างเนื้อหาการแจ้งเตือน
    final content = NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'การยืนยันตัวตน',
      body: 'คุณได้รับการอนุมัติในการยืนยันตัวตนแล้ว',
    );

    // ส่งการแจ้งเตือนไปยัง User
    AwesomeNotifications().createNotification(
      content: content,
      schedule: NotificationCalendar(),
      actionButtons: [
        NotificationActionButton(
          key: 'open_user_profile',
          label: 'เปิดโปรไฟล์ของคุณ',
          autoCancel: true,
        ),
      ],
      // displayed: true,
      // userId: userId,
    );
  }

  // void sendNotificationToSpecificDevice(String token) {
  //   final message = RemoteMessage(
  //     data: <String, String>{
  //       'type': 'notification',
  //       'title': 'Test Notification',
  //       'body': 'This is a test notification to a specific device.',
  //     },
  //     messageId: token,
  //   );

  //   FirebaseMessaging.instance.send(message);
  // }

  void _requestFirebaseMessagingForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  void _registerFirebaseMessagingToken() {
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    }).catchError((error) {
      print('Failed to get FCM token: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('FCM Notification Test'),
      ),
      body: Center(
        child: Text(
          'This is a test page for FCM notifications.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
