import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class GetQRCodePage extends StatefulWidget {
  final String qrCodeData;

  GetQRCodePage({required this.qrCodeData});

  @override
  _GetQRCodePageState createState() => _GetQRCodePageState();
}

class _GetQRCodePageState extends State<GetQRCodePage> {
  List<Map<String, dynamic>>? qrCodeListAsMap; // เพิ่มตัวแปรนี้ในส่วนของ State

  @override
  void initState() {
    super.initState();
    fetchQRCodeFromFirestore().then((fetchedQRCode) {
      setState(() {
        qrCodeListAsMap = fetchedQRCode;
        print('QR FS $qrCodeListAsMap');
      });
    });
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }

  Future<List<Map<String, dynamic>>?> fetchQRCodeFromFirestore() async {
    final userPIN = FirebaseAuth.instance.currentUser!.uid;
    final usersRefGetQR = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRefGetQR.doc(userPIN).get();

    if (snapshot.exists) {
      // return snapshot.get('QRCode');
      // final getCur = snapshot.get['getCode'];
      final qrCodeList = snapshot.get('QRCode') as List<dynamic>;
      final qrCodeListAsMap =
          qrCodeList.map((item) => Map<String, dynamic>.from(item)).toList();
      print('QR Code List: $qrCodeListAsMap');
      return qrCodeListAsMap;
    } else {
      return null;
    }
  }

  void _showQRCodeDialog(String qrCodeData, String keepCur, String keepDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('QR Code'),
          content: Container(
            width: 300,
            height: 320,
            child: QrImageView(
              data: qrCodeData,
              version: QrVersions.auto,
              size: 50,
            ),
          ),
          actions: <Widget>[
            Text('QR Code ${keepCur.toString()}, ${keepDate.toString()}'),
            ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  primary: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
        title: Text('Get QR Code'),
      ),
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
                        'QR Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (qrCodeListAsMap != null)
                      Expanded(
                        child: ListView.builder(
                          itemCount: qrCodeListAsMap!.length,
                          itemBuilder: (context, index) {
                            final userData = qrCodeListAsMap![index];
                            final keepCur = userData['Currency'];
                            final keepDate = userData['Date'];

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
                                    String qrCodeData =
                                        jsonEncode(qrCodeListAsMap![index]);
                                    _showQRCodeDialog(
                                        qrCodeData, keepCur, keepDate);
                                  },
                                  child: Text(
                                    'QR Code ${keepCur.toString()}, ${keepDate.toString()}',
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
