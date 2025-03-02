import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UpComingSuperAdminPage extends StatefulWidget {
  @override
  _UpComingSuperAdminPageState createState() => _UpComingSuperAdminPageState();
}

class _UpComingSuperAdminPageState extends State<UpComingSuperAdminPage> {
  String? _UID;
  String? Fname;
  String? Lname;
  String? Gender;
  String? dayBirth;
  String? monthBirth;
  String? yearBirth;
  String? idCard;
  String? phoneNumber;
  bool? checkStatusAdmin;
  bool? keepStatusAdmin;
  bool? isVerify = false;
  bool? isNotifyLocal = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Future<void> fetchData() async {
  //   final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
  //   final snapshotGet = await usersRefGet.doc("pin").get();
  //   if (snapshotGet.exists) {
  //     setState(() {
  //       _UID = snapshotGet.get('uid');
  //     });
  //   }

  //   final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  //   final snapshot = await usersRef.doc(_UID!).get();

  //   if (snapshot.exists) {
  //     setState(() {
  //       Fname = snapshot.get('FirstName');
  //       Lname = snapshot.get('LastName');
  //       Gender = snapshot.get('Gender');
  //       dayBirth = snapshot.get('DayofBirth');
  //       monthBirth = snapshot.get('MonthofBirth');
  //       yearBirth = snapshot.get('YearofBirth');
  //       idCard = snapshot.get('IDCardNumber');
  //       phoneNumber = snapshot.get('PhoneNumber');
  //       checkStatusAdmin = snapshot.get('ReservationStatusAdmin');
  //       keepStatusAdmin = snapshot.get('ConditionCheckAdmin');
  //     });
  //   }
  // }

  @override
  void initState() {
    //fetchData();
    super.initState();
    initializeNotifications();
  }

  Future<void> updateUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();

    if (snapshot.exists) {
      setState(() {
        checkStatusAdmin = true;
        keepStatusAdmin = true;
        isVerify = true;
        isNotifyLocal = true;
      });

      if (snapshot.data()!['DateReserva'] != null ||
          snapshot.data()!['DateReserva'] == null) {
        usersRef.doc(uid).update({
          'ReservationStatusAdmin': checkStatusAdmin,
          'ConditionCheckAdmin': keepStatusAdmin,
          'isVerify': isVerify,
          'isNotifyLocal': isNotifyLocal,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Save to Status on Firestore Success! (Update)',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to save Status on Firestore! (Update)',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  void sendNotificationBackground(String fcmToken) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAcMo1rAc:APA91bFgjfXcc0SJt0aeBr6X8ki8Z0CTg8YUTFANeybem04RvuXwIq5uglywI-hi_MG-jr1_KzyjKEay49eJVxjsCHtqoPp0DULiWaAWu7D89-Uk3QREwx8eitE_iKuhcU_DpdPTmM5B',
    };

    final body = jsonEncode({
      'to': fcmToken,
      'notification': {
        'title': 'Verification KYC',
        'body': 'You have been approved for verification.',
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  void sendNotificationForegroundAwesome() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: 'การยืนยันตัวตน',
          body: 'คุณได้รับการอนุมัติในการยืนยันตัวตนแล้ว',
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'open_user_profile',
            label: 'เปิดโปรไฟล์ของคุณ',
            autoCancel: true,
          ),
        ],
        schedule: NotificationCalendar());
  }

  void sendNotification(String fcmToken) async {
    if (Platform.isAndroid) {
      // ถ้าแอปพลิเคชันอยู่ใน Foreground (iOS)
      // sendNotificationForeground(fcmToken);
      sendNotificationForegroundAwesome();
    } else {
      // ถ้าแอปพลิเคชันอยู่ใน Background (Android)
      sendNotificationBackground(fcmToken);
    }
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS
    );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    // Handle notification tap action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Super'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usersPIN').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final bool isAdminStatusFalse =
                  userData['ConditionCheckAdmin'] == false &&
                      userData['ReservationStatusAdmin'] == false;
              if (isAdminStatusFalse) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Authenticate'),
                          content: Container(
                            height: 220,
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Do you want to verify this person\'s identity?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ''),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Gender: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              '${userData['Gender'] ?? 'Null'}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Date: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              '${userData['DayofBirth'] ?? 'Null'}:${userData['MonthofBirth'] ?? 'Null'}:${userData['YearofBirth'] ?? 'Null'}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'ID Card Number: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              '${userData['IDCardNumber'] ?? 'Null'}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Phone Number: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: '${userData['PhoneNumber']}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await updateUserData(userData['UID']);
                                sendNotificationBackground(
                                    userData['FCMToken']);
                                // sendNotificationForeground(
                                //     userData['FCMToken']);

                                // sendNotification(userData['FCMToken']);
                                print('token ${userData['FCMToken']}');

                                Navigator.of(context).pop();
                              },
                              child: Text('Allow'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Not Allow'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: ListTile(
                      // leading: checkStatusAdmin!
                      //     ? Icon(Icons.check_circle)
                      // : Icon(Icons.notification_important),
                      leading: Icon(Icons.notification_important),
                      title: Text(
                          '${userData['FirstName']} ${userData['LastName']} (${userData['Gender']})'),
                      subtitle: Text(
                          '${userData['DayofBirth']}:${userData['MonthofBirth']}:${userData['YearofBirth']}, ${userData['IDCardNumber']}, ${userData['PhoneNumber']}'),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
