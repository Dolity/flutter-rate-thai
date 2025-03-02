import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';

class ListQRPage extends StatefulWidget {
  @override
  _ListQRPage createState() => _ListQRPage();
}

class _ListQRPage extends State<ListQRPage> {
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

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID
  late String agencyValue = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                // final String _agency =
                //     userData != null && userData['QRCode'] != null
                //         ? userData['QRCode']['Agency'] ?? 'Null'
                //         : 'Null';

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
