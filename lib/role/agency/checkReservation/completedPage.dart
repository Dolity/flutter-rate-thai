import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
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

  void showImageDialog(String? imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: imageUrl != null
            ? Image.network(imageUrl, fit: BoxFit.contain)
            : Container(),
      ),
    );
  }

  void showDetailsDialog(Map<String, dynamic> userData) {
    final String _Total = userData['Total'];
    final String _DateReservation = userData['DateReserva'];
    final String _Type = userData['PayReserva'];
    final String _SubAgency = userData['SubAgencyReserva'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Container(
            height: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: GestureDetector(
                    onTap: () => showImageDialog(userData['imageUrl']),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: userData['imageUrl'] != null
                          ? NetworkImage(userData['imageUrl'] as String)
                          : AssetImage('assets/default_profile_picture.jpg')
                              as ImageProvider<Object>,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                Text('First Name: ${userData['FirstName']}'),
                Text('Last Name: ${userData['LastName']}'),
                Text('Gender: ${userData['Gender']}'),
                Text('Date: ${_DateReservation}'),
                Text('Value ${_Total}'),
                Text('Pay: ${_Type}'),
                Text('Subagency: ${_SubAgency}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed'),
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
                // final String _agency =
                //     userData != null && userData['QRCode'] != null
                //         ? userData['QRCode']['Agency'] ?? 'Null'
                //         : 'Null';

                return GestureDetector(
                  onTap: () => showDetailsDialog(userData),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('$_UserFName $_UserName $_Total THB'),
                      subtitle:
                          Text('${_DateReservation}, ${_SubAgency}, ${_Type}'),
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
