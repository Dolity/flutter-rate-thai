import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpComingPageSuper extends StatefulWidget {
  @override
  _UpComingPageSuperState createState() => _UpComingPageSuperState();
}

class _UpComingPageSuperState extends State<UpComingPageSuper> {
  String? _Cur;
  String? _Total;
  String? _Type;
  String? _Rate;
  String? _DateReservation;
  String? _SubAgency;
  bool? checkStatus;
  bool? keepStatus;
  String qrCodeData = '';
  String? _UID;
  bool? dropOffStatus;
  bool? isNotifyLocal = false;

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID
  late String agencyValue = '';

  @override
  void initState() {
    //fetchData();
    super.initState();
    currentUser = authen.currentUser;
    if (currentUser != null) {
      usernameData = currentUser!.email ?? "";
      userUID = currentUser!.uid;
    }
    getAgencyValue().then((value) {
      setState(() {
        agencyValue = value!;
      });
    });
  }

  Future<void> updateUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();

    if (snapshot.exists) {
      setState(() {
        checkStatus = true;
        keepStatus = true;
        dropOffStatus = true;
        isNotifyLocal = true;
        // isVerify = true;
      });

      if (snapshot.data()!['DateReserva'] != null ||
          snapshot.data()!['DateReserva'] == null) {
        usersRef.doc(uid).update({
          'ReservationStatus': checkStatus,
          'ConditionCheckAgency': keepStatus,
          'isNotifyLocal': isNotifyLocal,
          // 'DropOffStatus': dropOffStatus,
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
        'title': 'Currency Reservation',
        'body': 'You have been approved for Currency Reservation.',
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  Future<String?> getAgencyValue() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(userUID).get();

    if (snapshot != null && snapshot.exists) {
      // The document exists, now you can access its fields.
      final data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('agency')) {
        // Access the value of the "agency" field.
        final agencyValue = data['agency'];
        print('Agency Value: $agencyValue');
        return agencyValue;
      } else {
        print('Agency field not found or value is null.');
        return null;
      }
    } else {
      print('Document does not exist.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upcoming'),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersPIN')
            // .where('QRCode.Agency', isEqualTo: agencyValue)
            .snapshots(),
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
                  userData['ConditionCheckAgency'] == false &&
                      userData['ReservationStatus'] == false;
              final String _agency =
                  userData != null && userData['QRCode'] != null
                      ? userData['QRCode']['Agency'] ?? 'Null'
                      : 'Null';
              // final String _Rate = userData['QRCode']['Rate'] ?? 'Null';
              // final String _Amount = userData['QRCode']['Amount'] ?? 'Null';
              // final String _Total = userData['QRCode']['Total'] ?? 'Null';
              // final String _Currency = userData['QRCode']['Currency'] ?? 'Null';

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
                          title: Text('Booking Confirmation'),
                          content: Container(
                            height: 180,
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
                                            'Do you want to confirm this currency booking?',
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
                                      fontSize: 14,
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
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Receive: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: '${userData['Total']} THB'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Date: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: '${userData['DateReserva']}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'SubAgency: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              '${userData['SubAgencyReserva']}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Type: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: '${userData['PayReserva']}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await updateUserData(userData['UID']);
                                sendNotificationBackground(
                                    userData['FCMToken']);
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
                      leading: Icon(Icons.notification_important),
                      title: Text(
                          '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'} ${userData['Total']} THB'),
                      subtitle: Text(
                          '${userData['DateReserva']}, ${userData['SubAgencyReserva']}, ${userData['PayReserva']} ${_agency}'),
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
