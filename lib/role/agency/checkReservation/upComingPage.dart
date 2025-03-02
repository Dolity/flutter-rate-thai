import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpComingPage extends StatefulWidget {
  @override
  _UpComingPageState createState() => _UpComingPageState();
}

class _UpComingPageState extends State<UpComingPage> {
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

  List<Map<String, dynamic>>? qrCodeListAsMap;
  List<String>? filterList;
  String agencyValue = '';
  String agencyReservaValue = '';

  String dateReserva = '';
  String agencyReserva = '';
  String conditionQR = '';
  String subAgencyReserva = '';
  String uid = '';
  String conditionCheckAgency = '';
  String reservationStatus = '';
  String payReserva = '';
  List<Map<String, dynamic>> reservationList = [];
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
        agencyValue = value ?? "NULL";
        // qrCodeListAsMap = fetchedQRCode;
        print('init String agency :$qrCodeListAsMap');
      });
    });

    fetchData().then((value) {
      setState(() {
        agencyReservaValue = value ?? "NULL";
        print('init array agency: $agencyReservaValue');
      });
    });

    fetchReservationsFromFirestore().then((fetchedReservations) {
      setState(() {
        ReservationsListAsMap = fetchedReservations;
        print('Reservations FS $ReservationsListAsMap');
      });
    });

    // fetchData();

    // // เรียกใช้ฟังก์ชัน getAgencyValue() และ fetchData() และรอให้เสร็จสิ้นก่อน
    // Future.wait([getAgencyValue(), fetchData()]).then((values) {
    //   setState(() {
    //     agencyValue =
    //         values[0] ?? ""; // กำหนดค่า agencyValue จาก getAgencyValue()
    //     agencyReservaValue =
    //         values[1] ?? ""; // กำหนดค่า agencyReservaValue จาก fetchData()
    //   });
    // });

    // getDataFromFirestore();

    // getAllQRUserData().then((List<Map<String, dynamic>>? value) {
    //   if (value != null) {
    //     List<String> agencyReservaList =
    //         value.map((data) => data['AgencyReserva'] as String).toList();
    //     setState(() {
    //       filterList = agencyReservaList;
    //       print('init filterList: ${filterList![0]}');
    //     });
    //   } else {
    //     print('Value is null or not List<Map<String, dynamic>>');
    //   }
    // });
  }

  // Check if 'AgencyReserva' key exists before accessing it
  // if (userData.containsKey('AgencyReserva')) {
  //   print(userData['AgencyReserva'] ?? "AgencyReserva is null");
  // } else {
  //   // print("AgencyReserva key not found");
  // }
  Future<String?> fetchData() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.get();

    for (final doc in snapshot.docs) {
      final userData = doc.data();

      if (userData != null) {
        // Check if 'Reservations' key exists and is a list before accessing it
        if (userData.containsKey('Reservations') &&
            userData['Reservations'] is List) {
          final notes = userData['Reservations'] as List<dynamic>;

          for (final note in notes) {
            // Check if 'AgencyReserva' key exists and its value is "K79"
            if (note['AgencyReserva'] == agencyValue) {
              final agencyReservaValue = note['AgencyReserva'] ?? "NULL";
              // Update the agencyReservaValue and trigger a rebuild

              // setState(() {
              //   agencyReservaValue = note['AgencyReserva'];
              // });
              print('ArrayAgency: $agencyReservaValue');
              return agencyReservaValue;
            } else {
              print("AgencyReserva key not found or its value is not 'K79'");
            }
            // print(note['notes']);
            // print(note['user']);
          }
        } else {
          // print("Reservations key not found or not a list");
        }
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllQRUserData() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.get();

    if (snapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> qrCodeListAsMap = [];
      for (var doc in snapshot.docs) {
        final userData = doc.data() as Map<String, dynamic>;
        final qrCodeList = userData['Reservations'];
        if (qrCodeList != null && qrCodeList is List<dynamic>) {
          final qrCodeListFiltered = qrCodeList
              .where(
                  (reservation) => reservation['AgencyReserva'] == agencyValue)
              .toList();
          qrCodeListAsMap
              .addAll(qrCodeListFiltered.cast<Map<String, dynamic>>());
          // print('getAgency: $qrCodeListFiltered');
        } else {
          print('Reservations List is null or not a List<dynamic>');
        }
      }
      print('getAllQRUserData: $qrCodeListAsMap');

      List<String> filteredList = qrCodeListAsMap
          .where((data) => data['AgencyReserva'] == agencyValue)
          .map((data) => data['AgencyReserva'] as String)
          .toList();
      print('Filtered List: $filteredList');

      return qrCodeListAsMap;
    } else {
      print('No documents found in the collection.');
    }
    return null;
  }

  Future<void> updateUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();

    // final qrCodeListAsMap = await fetchQRCodeFromFirestore();

    if (snapshot.exists) {
      final qrCodeList = snapshot.get('Reservations') as List<dynamic>;
      final qrCodeListAsMap =
          qrCodeList.map((item) => Map<String, dynamic>.from(item)).toList();
      print('Reservations List: $qrCodeListAsMap');

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
        final agencyValue = data['agency'] ?? "NULL";
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

  Future<void> getDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('usersPIN').get();

      if (querySnapshot.size > 0) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          String agencyValue = data?['agency'] ?? 'N/A';
          List<dynamic> reservations = data?['Reservations'] ?? [];

          // กระทำแบบเร็กคอร์ดเพื่อค้นหาข้อมูลที่ต้องการใน array
          findDataInReservations(reservations);

          // print('Get Agency : $agencyValue');
        }
      } else {
        print('No documents found.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

// เมธอดเร็กคอร์ดในการค้นหาข้อมูลที่ต้องการใน array
  void findDataInReservations(List<dynamic> reservations) {
    for (var reservation in reservations) {
      if (reservation is Map<String, dynamic>) {
        String agencyReserva = reservation['AgencyReserva'] ?? '';
        if (agencyReserva == 'K79') {
          // กระทำกับข้อมูลที่ค้นหาเจอ
          print('Found data in Reservations: $reservation');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>?> fetchReservationsFromFirestore() async {
    // final userPIN = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.get();

    if (snapshot.docs.isNotEmpty) {
      final document = snapshot.docs.first;
      final ReservationsList = document.get('Reservations') as List<dynamic>;
      final ReservationsListAsMap =
          ReservationsList.map((item) => Map<String, dynamic>.from(item))
              .toList();
      print('Reservations List: $ReservationsListAsMap');
      return ReservationsListAsMap;
    } else {
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
            .where('role', isEqualTo: 'user')
            .where('AgencyReserva', isEqualTo: agencyValue)
            .snapshots(),
        // .where('AgencyReserva', isEqualTo: agencyReservaValue)
        // .where('AgencyReserva', isEqualTo: agencyValue)
        // .where('AgencyArr', arrayContains: agencyReservaValue)
        // .where("AgencyArr", arrayContains: agencyValue)
        // .where("AgencyArr", whereIn: ["SME"])
        // .where("Reservations",
        //     arrayContains: {"AgencyReserva": "K79"})
        // .where(agencyReservaValue, isEqualTo: agencyValue)
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;

          print('user : ${users.length}');
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

              if (userData.containsKey('Reservations') &&
                  userData['Reservations'] is List) {
                final reservations = userData['Reservations'] as List<dynamic>;

                // ตรวจสอบว่ามีข้อมูลใน List หรือไม่
                if (reservations.isNotEmpty) {
                  for (final reservation in reservations) {
                    if (reservation is Map<String, dynamic>) {
                      // ตรวจสอบค่า 'DateReserva' ใน Map ว่ามีค่าว่างเปล่าหรือไม่
                      if (reservation.containsKey('AgencyReserva') &&
                          reservation['AgencyReserva'] != null) {
                        // มีค่าข้อมูลไม่ว่างเปล่า จึงพิมพ์ค่าออกมา
                        // หากคุณต้องการเข้าถึงค่าอื่น ๆ ใน Map นี้ให้ดำเนินการตามต้องการของคุณ

                        // final dateReserva = reservation['DateReserva'];
                        // final agencyReserva = reservation['AgencyReserva'];
                        // final conditionQR = reservation['ConditionQR'];
                        // final subAgencyReserva =
                        //     reservation['SubAgencyReserva'];
                        // final uid = reservation['UID'];
                        // final conditionCheckAgency =
                        //     reservation['ConditionCheckAgency'];
                        // final reservationStatus =
                        //     reservation['ReservationStatus'];
                        // final payReserva = reservation['PayReserva'];

                        // final agencyReserva = reservation['AgencyReserva'];

                        // และเพิ่ม Map นี้ลงใน List reservationList
                        reservationList.add(reservation);

                        // ดำเนินการอื่น ๆ ที่คุณต้องการในรายการนี้
                      } else {
                        // ไม่มีค่าหรือเป็นค่าว่างเปล่า พิมพ์ค่า "Null" ออกมาแทน
                        print('DateReserva is null or empty');
                      }
                    } else {
                      print('Invalid data format in Reservations list');
                    }
                  }
                  // print(
                  //     'Array Of Map: $dateReserva, $subAgencyReserva, $payReserva, $agencyReserva');
                  print('All Reservations: $reservationList');
                  print('List: ${reservationList[0]['AgencyReserva']}');
                  print(
                      'AdminStatus: ${reservationList[0]['SubAgencyReserva']}');
                } else {
                  // ไม่มีข้อมูลใน List พิมพ์ค่า "Reservations is empty" ออกมาแทน
                  print('Reservations is empty');
                }
              } else {
                // ไม่มี key 'Reservations' หรือ 'Reservations' ไม่ใช่ List พิมพ์ค่า "Reservations key not found or not a list" ออกมาแทน
                print('Reservations key not found or not a list');
              }

              // print('Widget User: $userData');
              // final qrCodeList = userData['Reservations'];
              // if (qrCodeList != null && qrCodeList is List<dynamic>) {
              //   final agencyReservaList = qrCodeList
              //       .map((reservation) => reservation['AgencyReserva'])
              //       .toList();
              //   print('AgencyReserva List: ${agencyReservaList[0]}');
              // } else {
              //   print('Reservations List is null or not a List<dynamic>');
              // }

              // if (qrCodeList != null && qrCodeList is List<dynamic>) {
              //   final qrCodeListAsMap = qrCodeList
              //       .map((item) => Map<String, dynamic>.from(item))
              //       .toList();
              //   print('Reservations List: $qrCodeListAsMap');
              //   // ดำเนินการอื่น ๆ ที่ต้องทำในรายการนี้
              // } else {
              //   print('Reservations List is null or not a List<dynamic>');
              // }

              // print('QR Agency: ${qrCodeList[index]['AgencyReserva']}');

              // final String _Rate = userData['QRCode']['Rate'] ?? 'Null';

              // final String _Amount = userData['QRCode']['Amount'] ?? 'Null';
              // final String _Total = userData['QRCode']['Total'] ?? 'Null';
              // final String _Currency = userData['QRCode']['Currency'] ?? 'Null';

              // ก่อนที่คุณใช้ for ให้ตรวจสอบก่อนว่า reservationList มีข้อมูลหรือไม่

              if (reservationList.isNotEmpty) {
                String subtitleText = '';
                for (final reservation in reservationList) {
                  print('All Reservations IF: $reservationList');
                  print('User: ${reservationList.length}');
                  // final reservation = reservationList[i];

                  if (reservation.containsKey('DateReserva') &&
                      reservation.containsKey('SubAgencyReserva') &&
                      reservation.containsKey('PayReserva')) {
                    final dateReserva = reservation['DateReserva'];
                    final subAgencyReserva = reservation['SubAgencyReserva'];
                    final payReserva = reservation['PayReserva'];

                    // เพิ่มข้อมูลลงใน subtitleText แยกด้วยเครื่องหมาย ,
                    subtitleText +=
                        '$dateReserva, $subAgencyReserva, $payReserva ${agencyValue}, ';

                    // if (reservation['ConditionCheckAgency'] == false) {

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          print('loop user: $reservation');
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
                                              text:
                                                  '${userData['DateReserva']}'),
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
                                              text:
                                                  '${userData['PayReserva']}'),
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
                          // title: Text(
                          //     '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'} ${userData['Total']} THB'),
                          // subtitle: Text(
                          //     '${userData['DateReserva'] ?? 'Null'}, ${userData['SubAgencyReserva'] ?? 'Null'}, ${userData['PayReserva'] ?? 'Null'} ${agencyValue}'),

                          title: Text(
                              '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'} ${userData['Total']} THB'),
                          // subtitle: Text('${[
                          //       'DateReserva'
                          //     ] ?? 'Null'}, ${reservation['SubAgencyReserva'] ?? 'Null'}, ${reservation['PayReserva'] ?? 'Null'} ${agencyValue}'),
                          subtitle: Text(subtitleText),
                        ),
                      ),
                    );
                  }
                }
              }
              // } else {
              //   return SizedBox.shrink();
              // }
            },
          );
        },
      ),
    );
  }
}
