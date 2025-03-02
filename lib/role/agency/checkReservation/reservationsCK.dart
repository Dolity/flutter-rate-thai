import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';

class reservationsCKPage extends StatefulWidget {
  final String uidQR;
  reservationsCKPage({required this.uidQR});

  @override
  _reservationsCKPage createState() => _reservationsCKPage();
}

class _reservationsCKPage extends State<reservationsCKPage> {
  String? _Cur;
  String? _Total;
  String? _Type;
  String? _Rate;
  String? _DateReservation;
  String? _SubAgency;
  String? _fromUID;
  bool checkStatus = false;
  bool keepStatus = false;
  String qrCodeData = '';
  String uidQR = '';

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID
  late String agencyValue = '';
  bool? isNotifyLocal = false;
  List<Map<String, dynamic>>? ReservationsListAsMap;

  @override
  void initState() {
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

    fetchReservationsFromFirestore().then((fetchedReservations) {
      setState(() {
        ReservationsListAsMap = fetchedReservations;
        print('Reservations FS $ReservationsListAsMap');
      });
    });
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

  Future<void> QRUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();
  }

  Future<List<Map<String, dynamic>>?> fetchReservationsFromFirestore() async {
    // final userPIN = FirebaseAuth.instance.currentUser!.uid;
    // final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    // final snapshot = await usersRef.get();
    final usersRefGetQR = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRefGetQR.doc(widget.uidQR).get();

    if (snapshot.exists) {
      final ReservationsList = snapshot.get('ReservationArr') as List<dynamic>;
      final ReservationsListAsMap =
          ReservationsList.map((item) => Map<String, dynamic>.from(item))
              .toList();
      print('Reservations List: $ReservationsListAsMap');
      return ReservationsListAsMap;
    } else {
      return null;
    }
  }

  Future<void> updateUserData() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(widget.uidQR).get();

    if (snapshot.exists) {
      setState(() {
        checkStatus = true;
        keepStatus = true;
        // dropOffStatus = true;
        isNotifyLocal = true;
        // isVerify = true;
      });

      if (snapshot.data() != null || snapshot.data() == null) {
        // var reservationData = {
        //   'ReservationStatusArr': checkStatus,
        //   'ConditionCheckAgencyArr': keepStatus,
        //   'isNotifyLocal': isNotifyLocal,
        // };

        // usersRef.doc(widget.uidQR).update({
        //   'ReservationArr': FieldValue.arrayUnion([reservationData]),
        // }

        usersRef.doc(widget.uidQR).update({
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

  @override
  Widget build(BuildContext context) {
    print('pass UID: ${widget.uidQR}');
    print('UDI: $uidQR');
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Confirmation'),
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('usersPIN')
      //       // .where('UID', isEqualTo: widget.uidQR)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     final users = snapshot.data!.docs;

      //     return ListView.builder(
      //       itemCount: users.length,
      //       itemBuilder: (context, index) {
      //         final userData = users[index].data() as Map<String, dynamic>;
      //         final bool isAdminStatusTrue =
      //             userData['ConditionCheckAgency'] == true &&
      //                 userData['ReservationStatus'] == true;
      //         // if (isAdminStatusTrue) {
      //         final String _Total = userData['Total'];
      //         final String _DateReservation = userData['DateReserva'];
      //         final String _Type = userData['PayReserva'];
      //         final String _SubAgency = userData['SubAgencyReserva'];
      //         final String _UserFName = userData['FirstName'] ?? 'Null';
      //         final String _UserName = userData['LastName'] ?? 'Null';
      //         final String _Gender = userData['Gender'] ?? 'Null';
      //         final String _agency =
      //             userData != null && userData['QRCode'] != null
      //                 ? userData['QRCode']['Agency'] ?? 'Null'
      //                 : 'Null';

      //         return Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             child: InkWell(
      //               onTap: () {
      //                 showDialog(
      //                   context: context,
      //                   builder: (context) => AlertDialog(
      //                     title: Text('Scan QR Code Confirmation'),
      //                     content: Container(
      //                       height: 110,
      //                       child: Column(
      //                         children: [
      //                           RichText(
      //                             text: TextSpan(
      //                               style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontSize: 16,
      //                               ),
      //                               children: [
      //                                 TextSpan(
      //                                   text:
      //                                       'Do you want to confirm this money scan?',
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                                 TextSpan(text: ''),
      //                               ],
      //                             ),
      //                           ),
      //                           SizedBox(height: 15),
      //                           RichText(
      //                             text: TextSpan(
      //                               style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontSize: 16,
      //                               ),
      //                               children: [
      //                                 TextSpan(
      //                                   text: 'Name: ',
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                                 TextSpan(
      //                                     text:
      //                                         '$_UserFName $_UserName ($_Gender)'),
      //                               ],
      //                             ),
      //                           ),
      //                           RichText(
      //                             text: TextSpan(
      //                               style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontSize: 16,
      //                               ),
      //                               children: [
      //                                 TextSpan(
      //                                   text: 'Receive: ',
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                                 TextSpan(
      //                                     text: '${userData['Total']} THB'),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                     actions: [
      //                       TextButton(
      //                         onPressed: () async {
      //                           await QRUserData(userData['UID']);
      //                           Navigator.push(context,
      //                               MaterialPageRoute(builder: (context) {
      //                             return QRScanPage(uidQR: userData['UID']);
      //                           }));
      //                         },
      //                         child: Text('Allow'),
      //                       ),
      //                       TextButton(
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                         },
      //                         child: Text('Not Allow'),
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               },
      //               child: ListTile(
      //                 leading: Icon(Icons.notifications_active_outlined),
      //                 title: Text('$_UserFName $_UserName $_Total THB'),
      //                 // subtitle: Text(
      //                 //     '${_DateReservation}, ${_SubAgency}, ${_Type}, ${_agency}'),
      //               ),
      //             ));
      //         // } else {
      //         //   return SizedBox.shrink();
      //         // }
      //       },
      //     );
      //   },
      // ),

      body: Row(
        children: [
          Container(
            width: 370,
            height: 500,
            margin: EdgeInsets.all(10),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'Currency Confirmation',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (ReservationsListAsMap != null)
                      Expanded(
                        child: ListView.builder(
                          itemCount: ReservationsListAsMap!.length,
                          itemBuilder: (context, index) {
                            final userData = ReservationsListAsMap![index];
                            final keepCur = userData['SubAgencyReservaArr'];

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: ElevatedButtonTheme(
                                data: ElevatedButtonThemeData(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    primary: Colors.black54,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // แสดง QR Code ที่ตำแหน่ง index ที่กดปุ่ม
                                    // String qrCodeData =
                                    //     jsonEncode(qrCodeListAsMap![index]);
                                    // _showQRCodeDialog(qrCodeData);
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
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                      text: 'Agency: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '${userData['AgencyReservaArr'] ?? 'Null'}'),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '${userData['SubAgencyReservaArr'] ?? 'Null'}'),
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
                                                      text: 'Pay: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '${userData['PayReservaArr'] ?? 'Null'}'),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '${userData['DateReservaArr'] ?? 'Null'}'),
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
                                              await updateUserData();
                                              // sendNotificationBackground(
                                              //     userData['FCMToken']);

                                              // await fetchReservationsFromFirestore(
                                              //     userData['UID']);
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
                                  child: Text(
                                    'Currency Confirmation ${keepCur.toString()}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
