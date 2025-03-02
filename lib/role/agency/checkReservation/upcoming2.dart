import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testprojectbc/role/agency/checkReservation/reservationsCK.dart';

class UpComing2Page extends StatefulWidget {
  @override
  _UpComingPage2State createState() => _UpComingPage2State();
}

class _UpComingPage2State extends State<UpComing2Page> {
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
  List<Map<String, dynamic>>? ReservationsListAsMap;

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

  Future<List<Map<String, dynamic>>?> fetchReservationsFromFirestore(
      String uid) async {
    final usersRefGetQR = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRefGetQR.doc(uid).get();

    if (snapshot.exists) {
      final ReservationsList = snapshot.get('ReservationArr') as List<dynamic>;
      final ReservationsListAsMap =
          ReservationsList.map((item) => Map<String, dynamic>.from(item))
              .toList();
      print('QR Code List: $ReservationsListAsMap');
      return ReservationsListAsMap;
    } else {
      return null;
    }
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
        final agencyValue = data['agency'] ?? 'Null';
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

  // StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getUsersStream(
  //     String agencyValue) {
  //   return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  //     stream: FirebaseFirestore.instance
  //         .collection('usersPIN')
  //         .where('role', isEqualTo: 'user')
  //         .where('AgencyReserva', isEqualTo: agencyValue)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }

  //       if (snapshot.hasError) {
  //         // ตรวจสอบว่ามีข้อผิดพลาดหรือไม่
  //         return Center(
  //           child: Text('Error: ${snapshot.error}'),
  //         );
  //       }

  //       final users = snapshot.data!.docs;
  //       // ดำเนินการกับข้อมูล users ตามที่คุณต้องการ

  //       return UpComing2Page(); // คืนค่า Widget ที่คุณต้องการแสดง
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upcoming'),
      // ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usersPIN')
              .where('role', isEqualTo: 'user')
              .where('AgencyReserva', isEqualTo: agencyValue)
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
              itemBuilder: (BuildContext context, int index) {
                final userData = users[index].data() as Map<String, dynamic>;

                // final userData = users[index].data() as Map<String, dynamic>;
                final bool isAdminStatusFalse =
                    userData['ConditionCheckAgency'] == false &&
                        userData['ReservationStatus'] == false;

                // final String _agency =
                //     userData != null && userData['QRCode'] != null
                //         ? userData['QRCode']['Agency'] ?? 'Null'
                //         : 'Null';

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
                                  Navigator.of(context).pop();
                                  // await updateUserData(userData['UID']);
                                  // sendNotificationBackground(
                                  //     userData['FCMToken']);

                                  // await fetchReservationsFromFirestore(
                                  //     userData['UID']);

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return reservationsCKPage(
                                        uidQR: userData['UID']);
                                  }));
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
                        // subtitle: Text(
                        //     '${userData['DateReserva']}, ${userData['SubAgencyReserva']}, ${userData['PayReserva']} ${_agency}'),
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
      ),
    );
  }
}
