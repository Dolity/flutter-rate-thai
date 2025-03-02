import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';

class ListQRPageSuper extends StatefulWidget {
  @override
  _ListQRSuperPage createState() => _ListQRSuperPage();
}

class _ListQRSuperPage extends State<ListQRPageSuper> {
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

  @override
  void initState() {
    // fetchData();
    super.initState();
  }

  Future<void> QRUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();

    // if (snapshot.exists) {
    //   setState(() {
    //     // isVerify = true;
    //   });

    //   if (snapshot.data()!['DateReserva'] != null ||
    //       snapshot.data()!['DateReserva'] == null) {
    //     usersRef.doc(uid).update({
    //       'ReservationStatus': checkStatus,
    //       'ConditionCheckAgency': keepStatus,
    //       // 'DropOffStatus': dropOffStatus,
    //     }).then((_) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text(
    //             'Save to Status on Firestore Success! (Update)',
    //           ),
    //           duration: Duration(seconds: 2),
    //         ),
    //       );
    //     }).catchError((error) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text(
    //             'Failed to save Status on Firestore! (Update)',
    //           ),
    //           duration: Duration(seconds: 2),
    //         ),
    //       );
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
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
              final bool isAdminStatusTrue =
                  userData['ConditionCheckAgency'] == true &&
                      userData['ReservationStatus'] == true;
              if (isAdminStatusTrue) {
                final String _Total = userData['Total'];
                final String _DateReservation = userData['DateReserva'];
                final String _Type = userData['PayReserva'];
                final String _SubAgency = userData['SubAgencyReserva'];
                final String _UserFName = userData['FirstName'] ?? 'Null';
                final String _UserName = userData['LastName'] ?? 'Null';
                final String _Gender = userData['Gender'] ?? 'Null';

                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Scan QR Code Confirmation'),
                            content: Container(
                              height: 110,
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
                                              'Do you want to confirm this money scan?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: ''),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
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
                                                '$_UserFName $_UserName ($_Gender)'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
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
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await QRUserData(userData['UID']);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return QRScanPage(uidQR: userData['UID']);
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
                        leading: Icon(Icons.notifications_active_outlined),
                        title: Text('$_UserFName $_UserName $_Total THB'),
                        subtitle: Text(
                            '${_DateReservation}, ${_SubAgency}, ${_Type}'),
                      ),
                    ));
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
