import 'dart:io';

import 'package:testprojectbc/page/Setting/makePin.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testprojectbc/main.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initFirebaseMessaging(BuildContext context) async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Get Notify: ${message.notification?.title}, ${message.notification?.body}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Handle message when app is in foreground
        print(
            ".......................opened from notification foreground WORK!.......................");
        print(
            "onMessage: ${message.notification?.title}/${message.notification?.body}");

        showNotification(
            title: notification.title ?? '', body: notification.body ?? '');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          ".......................opened from notification background WORK!.......................");
      print(
          "onMessageOpenedApp: ${message.notification?.title}/${message.notification?.body}");
      // Handle message when app is opened from notification background
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CreatePinPage(
            // title: message.notification?.title,
            // body: message.notification?.body,
            ),
      ));
    });
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'payload',
    );
  }
}
