import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:testprojectbc/models/qrModel.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;

class QRCodePage extends StatefulWidget {
  final String user;
  QRCodePage({required this.user});

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  TextEditingController _textEditingControllerQR = TextEditingController();
  String _qrCodeData = '';
  String _dateReserva = '';
  String _payReserva = '';
  String _subAgencyReserva = '';
  String _total = '';
  String _fname = '';
  String _lname = '';
  String _gender = '';
  String _uidQR = '';
  late final qrCodeDataProvider;
  bool? isVerify;
  bool? isReservation;
  final user = FirebaseAuth.instance.currentUser!.uid;

  void checkReservation() async {
    // Check Firestore for isVerify data
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(user).get();

    // isVerify = snapshot.get('isVerify') ?? false;
    isVerify = snapshot.data()!.containsKey('isVerify')
        ? snapshot.get('isVerify')
        : false;

    isReservation = snapshot.data()!.containsKey('ConditionCheckAgency')
        ? snapshot.get('ConditionCheckAgency')
        : false;

    print('isVerify: $isVerify');

    setState(() {
      isVerify = isVerify;
      isReservation = isReservation;
    });
    print('Set State isVerify: $isVerify');

    if (!isReservation!) {
      print('isReservation: $isVerify');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            ),
            title: Text(
                'You have not been authorized by the company to reserve currency'),
            content: Text(
                'Please wait for the company to confirm the currency reservation.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context); // ปิด AlertDialog
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => LoginSuccessPage()),
                  // );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReservationData();
    checkReservation();
  }

  Future<void> fetchReservationData() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('usersPIN')
          .doc(user)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        setState(() {
          _dateReserva = data['DateReserva'] ?? '';
          _payReserva = data['PayReserva'] ?? '';
          _subAgencyReserva = data['SubAgencyReserva'] ?? '';
          _fname = data['FirstName'] ?? '';
          _lname = data['LastName'] ?? '';
          _gender = data['Gender'] ?? '';
          _uidQR = data['UID'] ?? '';
        });
      }

      usersRef.doc(user).update({
        'Total': '$_total',
      });
      print('UID user:  ${user}');
      // globals.globalUID = user;

      print('UID widget:  ${globals.globalUID}');
    } catch (error) {
      print('Error fetching reservation data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String agency =
        context.watch<ReservationData>().resevaProviAgencyUpdate.toString();
    String currency = context.watch<ReservationData>().resevaFromCur.toString();
    String rate =
        context.watch<ReservationData>().resevaProviRateUpdate.toString();
    String amount = context.watch<ReservationData>().resevaAmount.toString();
    _total = ((double.parse(rate)) * (double.tryParse(amount ?? '0.0') ?? 0.0))
        .toStringAsFixed(2);
    final qrCodeDataProvider =
        Provider.of<ReservationData>(context, listen: false);
    var notesServices = context.watch<NotesServices>();

    return notesServices.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('QR Code Generator'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TextField(
                  //   controller: _textEditingControllerQR,
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter data',
                  //   ),
                  // ),
                  // SizedBox(height: 16),

                  ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        primary: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        print(
                            "DataProvider: $agency, $currency, $rate, $amount");
                        print(
                            "getFireStore: $_dateReserva, $_subAgencyReserva, $_payReserva");
                        print('total Money: $_total');
                        print(
                            'Fname: $_fname, Lname: $_lname, Gender: $_gender');
                        final jsonMap = {
                          'Agency': agency,
                          'Currency': currency,
                          'Rate': rate,
                          'Amount': amount,
                          'Total': _total,
                          'Date': _dateReserva,
                          'SubAgency': _subAgencyReserva,
                          'Pay': _payReserva,
                          'Uid': _uidQR,
                        };
                        final jsonReservationData = jsonEncode(jsonMap);
                        setState(() {
                          _qrCodeData = jsonReservationData;
                        });
                        final qrCodeData = QRCodeData.fromJson(jsonMap);
                        qrCodeDataProvider.setQRCodeData(qrCodeData);

                        // เริ่มต้นเก็บค่า QR Code ลงใน Firestore ในฟังก์ชัน build ไม่ใช้ initState
                        if (jsonMap != null) {
                          final userPIN =
                              FirebaseAuth.instance.currentUser!.uid;
                          final usersRef =
                              FirebaseFirestore.instance.collection('usersPIN');
                          usersRef.doc(userPIN).update({
                            'QRCode': FieldValue.arrayUnion([jsonMap]),
                          });
                          print('QR Crate to FS');
                        }

                        notesServices.addNote(agency, currency, rate, amount,
                            _total, _dateReserva, _fname, _lname, _gender);

                        Fluttertoast.showToast(
                          msg: 'Reservation Save On Blockchian Success \u2714',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                        );

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginSuccessPage();
                        }));

                        print('object: $_qrCodeData');
                        print('Data on BC: ${notesServices.notes}');
                      },
                      child: Text(
                        'Generate QR Code',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _qrCodeData.isNotEmpty
                      ? QrImageView(
                          data: _qrCodeData,
                          version: QrVersions.auto,
                          size: 200.0,
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
