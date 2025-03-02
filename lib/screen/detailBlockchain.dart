import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:testprojectbc/Service/singleton/userUID.dart';

class DetailBCPage extends StatefulWidget {
  final String firstnameBC;
  final String lastnameBC;
  final String genderBC;
  final String agencyBC;
  final String rateBC;
  final String currencyBC;
  final String totalBC;
  final String dateBC;
  final String amountBC;

  DetailBCPage(
      {required this.firstnameBC,
      required this.lastnameBC,
      required this.genderBC,
      required this.agencyBC,
      required this.rateBC,
      required this.currencyBC,
      required this.totalBC,
      required this.dateBC,
      required this.amountBC});

  @override
  _DetailBCPage createState() => _DetailBCPage();
}

@override
class _DetailBCPage extends State<DetailBCPage> {
  String? _Total;
  String? _Type;
  String? _DateReservation;
  String? _SubAgency;
  String? _Fname;
  String? _Lname;
  String? _Gender;
  String? _UID;
  String? amountBC;

  Future<void> fetchData() async {
    String? user = UserSingleton().uid;
    print('UID Sigerton: $user');

    // บันทึกข้อมูลใน Firestore หาก user ไม่เป็น null
    // if (user != null) {
    // final usersRefUpdate = FirebaseFirestore.instance.collection('keepUID');
    // await usersRefUpdate.doc("pin").update({'uid': user});
    // print('UID Saved');

    // ดึงข้อมูลจาก Firestore ตามปกติ
    // final usersRef2 = FirebaseFirestore.instance.collection('usersPIN');
    // final snapshot = await usersRef2.doc(user).get();
    // if (snapshot.exists) {
    //   setState(() {
    //     _Fname = snapshot.get('FirstName');
    //     _Lname = snapshot.get('LastName');
    //     _Gender = snapshot.get('Gender');
    //     _Total = snapshot.get('Total');
    //     _DateReservation = snapshot.get('DateReserva');
    //     _Type = snapshot.get('PayReserva');
    //     _SubAgency = snapshot.get('SubAgencyReserva');
    //     // _UID = snapshot.get('UID');
    //   });
    // }
    // } else {
    print('User Null But Found UID ON FS');
    final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
    final snapshotGet = await usersRefGet.doc("pin").get();
    if (snapshotGet.exists) {
      setState(() {
        _UID = snapshotGet.get('uid');
      });
    }
    print('UID FS: $_UID');

    // ดึงข้อมูลจาก Firestore ด้วย _UID ที่ได้จาก Firestore ก่อนหน้า
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(_UID).get();
    if (snapshot.exists) {
      setState(() {
        // _Fname = snapshot.get('FirstName');
        // _Lname = snapshot.get('LastName');
        // _Gender = snapshot.get('Gender');
        // _Total = snapshot.get('Total');
        // _DateReservation = snapshot.get('DateReserva');
        _Type = snapshot.get('PayReserva');
        _SubAgency = snapshot.get('SubAgencyReserva');
      });
    }
    //}
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Page')),
      body: SizedBox(
        height: 280,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          elevation: 8,
          child: InkWell(
            onTap: () {
              // Do something when the ListTile is tapped
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                dense: true,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Data On Blockchain",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '${widget.firstnameBC} ${widget.lastnameBC}'),
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
                            text: 'Gender: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.genderBC}'),
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
                            text: 'Agency: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.agencyBC}'),
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
                            text: 'Pick Up Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.dateBC}'),
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
                            text: 'Currency: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.currencyBC}'),
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
                            text: 'Rate: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.rateBC}'),
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
                            text: 'Amount: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.amountBC}'),
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
                            text: 'Value: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${widget.totalBC}'),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 5),
                    // RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: 'Pay: ',
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       TextSpan(text: '${_Type}'),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 5),
                    // RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: 'Pick Up Address: ',
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       TextSpan(text: '${_SubAgency}'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
