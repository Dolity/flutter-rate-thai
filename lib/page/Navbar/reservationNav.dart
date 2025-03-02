import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Reservation/detailAgency.dart';
import 'package:testprojectbc/page/Reservation/detailCur.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';

import '../curinfo2.dart';
import '../login.dart';
import 'loginsuccess.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReservationNav extends StatefulWidget {
  @override
  _ReservationNav createState() => _ReservationNav();
  static const String routeName = '/ReservationNav'; // เพิ่มตรงนี้
}

class _ReservationNav extends State<ReservationNav> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _currencies = [
    'AED',
    'AUD',
    'BHD',
    'BND',
    'CAD',
    'CHF',
    'CNY',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'IDR',
    'INR',
    'JOD',
    'JPY',
    'KRW',
    'KWD',
    'LAK',
    'MMK',
    'MOP',
    'MYR',
    'NOK',
    'NPR',
    'NZD',
    'OMR',
    'PHP',
    'QAR',
    'RUB',
    'SAR',
    'SEK',
    'SGD',
    'TRY',
    'TWD',
    'USD',
    'VND',
    'ZAR'
  ];
  String? _fromCurrency = 'USD';
  String? _toCurrency = 'THB';
  final String? _agenName = '';
  double? _exchangeRate = 0.0;

  double? maxSellRate = 0.0;
  String? maxSellRateAgen = '';
  var highestSellRate = 0.0;

  bool showPadding = false;

  Set<String> allAgenNames = {};
  List<String> agenNamesList = [];
  Set<double> allSellRate = {};
  final userUID = FirebaseAuth.instance.currentUser!.uid;
  bool? isVerify;
  bool? isReservation;

  var sellRateComparator =
      (double a, double b) => b.compareTo(a); // เรียงลำดับจากมากไปหาน้อย
  bool isVerified = false; // เพิ่มตัวแปร isVerified ใน State
  int currentIndex = 2; // ตรงนี้คือการประกาศตัวแปร currentIndex

  @override
  void initState() {
    super.initState();
    // checkVerificationStatus(); // เรียกใช้ฟังก์ชัน checkVerificationStatus ใน initState
    // checkClickReservation();
    checkKYC();
  }

  void checkKYC() async {
    // Check Firestore for isVerify data
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(userUID).get();

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

    if (!isVerify!) {
      print('isVerify: $isVerify');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => VerificationPage()),
      // );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            ),
            title: Text('You haven\'t verified your identity yet'),
            content: Text('Please verify your identity to use.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context); // ปิด AlertDialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginSuccessPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  // void checkVerificationStatus() async {
  //   print('checkVerificationStatus OK');
  //   final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  //   final querySnapshot = await usersRef.where('UID', isEqualTo: userUID).get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     print('querySnapshotdoc OK');
  //     final documentSnapshot = querySnapshot.docs.first;
  //     final isVerified = documentSnapshot.get('isVerify');
  //     setState(() {
  //       this.isVerified = isVerified ?? false;
  //       print('isVerified: $isVerified');
  //     });
  //   }
  // }

  // void checkClickReservation() async {
  //   if (currentIndex == 2) {
  //     if (isVerified) {
  //       // ถ้าผู้ใช้ยืนยันตัวตนแล้วให้ไปที่หน้า ReservationNav
  //       setState(() {
  //         currentIndex = 2;
  //       });
  //     } else {
  //       // ถ้าผู้ใช้ยังไม่ได้ยืนยันตัวตนให้ไปที่หน้า VerificationPage
  //       final result = await Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => VerificationPage()),
  //       );
  //       if (result == true) {
  //         setState(() {
  //           currentIndex = 2;
  //           isVerified = true;
  //         });
  //       } else {
  //         setState(() {
  //           currentIndex = 0;
  //         });
  //       }
  //     }
  //   }
  //   print('currIDX: $currentIndex');
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      UserSingleton().setUID(uid);
    }
    String? uid = UserSingleton().uid;
    print("Click UID: ${uid}");

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/bgnavReservation2.jpg'), // เพิ่มรูปภาพที่ต้องการ
                fit: BoxFit.cover,
              ),
            ),
            // height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 75, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              // onTap: () {
                              //   print('facebook');
                              //   loginWithFacebook(context);
                              // },
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Reserve Currency",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 350,
                            height: 450,
                            child: Card(
                              color: Color.fromARGB(0, 255, 255, 255)
                                  .withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DropdownButton<String>(
                                            value: _fromCurrency,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _fromCurrency = value;
                                                print(
                                                    'fromCurrency: $_fromCurrency');
                                              });
                                            },
                                            items: _currencies
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward_ios),
                                            onPressed: () {},
                                          ),
                                          DropdownButton<String>(
                                            value: _toCurrency,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _toCurrency = value;
                                                print(
                                                    'toCurrency: $_toCurrency');
                                              });
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('THB'),
                                                value: 'THB',
                                              ),
                                              // Add more currencies here
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: _textEditingController,
                                        validator: RequiredValidator(
                                            errorText: "กรุณาใส่ค่าตัวเลข"),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                            hintText: '0.00',
                                            hintStyle: TextStyle(fontSize: 30)),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        // decoration: BoxDecoration(
                                        //   color: Color.fromRGBO(192, 238, 242, 1),
                                        //   borderRadius: BorderRadius.circular(50),
                                        // ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${_textEditingController.text} $_fromCurrency = ${((_exchangeRate ?? 0.0) * (double.tryParse(_textEditingController?.text?.toString() ?? '0.0') ?? 0.0)).toStringAsFixed(2)} THB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              '1 $_fromCurrency = ${(_exchangeRate ?? 0.0).toStringAsFixed(2)} THB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // เพิ่ม Widget อื่น ๆ ตามต้องการ
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async {
                                          allSellRate.clear();
                                          highestSellRate = 0.0;
                                          var message = "";
                                          message = "กรุณาใส่ค่าตัวเลข";
                                          if (_textEditingController
                                              .text.isEmpty) {
                                            setState(() {
                                              _exchangeRate = 0.0;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(message)));
                                            print('Error: Please enter amount');

                                            Container myContainer() {
                                              return Container(
                                                  // Container properties
                                                  );
                                            }

                                            return;
                                          } else {
                                            //var apiKey = 'e50a59e299ef0bae5bc03139';
                                            var url =
                                                //'https://v6.exchangerate-api.com/v6/$apiKey/latest/$_fromCurrency';
                                                'https://back-end-rate-thai.vercel.app/getagencies/$_fromCurrency';
                                            var response =
                                                await http.get(Uri.parse(url));
                                            print('before response');
                                            if (response.statusCode == 200) {
                                              print('if response OK');

                                              var jsonResponse =
                                                  jsonDecode(response.body);
                                              print(jsonResponse);
                                              if (jsonResponse is List &&
                                                  jsonResponse.isNotEmpty) {
                                                var agencies = jsonResponse;
                                                //var conversionMap = Map<String, dynamic>();
                                                var conversionList =
                                                    <Map<String, dynamic>>[];

                                                for (var agency in agencies) {
                                                  if (agency is Map &&
                                                      agency.containsKey(
                                                          'agency') &&
                                                      agency is Map &&
                                                      agency.containsKey(
                                                          'agenName')) {
                                                    var agencyData =
                                                        agency['agency'];

                                                    if (agencyData is List &&
                                                        agencyData.isNotEmpty) {
                                                      for (var data
                                                          in agencyData) {
                                                        if (data is Map &&
                                                            data.containsKey(
                                                                'cur') &&
                                                            data.containsKey(
                                                                'sell')) {
                                                          var agenName = agency[
                                                              'agenName'];
                                                          String currency =
                                                              data['cur'];
                                                          double sellRate =
                                                              double.parse(
                                                                  data['sell']);
                                                          // conversionMap[currency] = {
                                                          //   'agenName': agenName,
                                                          //   'sellRate': sellRate
                                                          // }; // เพิ่ม agenName ลงใน conversionMap พร้อมกับ sellRate

                                                          var conversionData = {
                                                            'agenName':
                                                                agenName,
                                                            'sellRate': sellRate
                                                          };
                                                          print(
                                                              "**************** Agen: ${agenName}  ||| Sell: ${sellRate}  ||| Cur: ${currency}  ****************");

                                                          // ตรวจสอบค่าซ้ำกันก่อนเพิ่มเข้าไปใน conversionList
                                                          if (!conversionList.any((element) =>
                                                              element['agenName'] ==
                                                                  conversionData[
                                                                      'agenName'] &&
                                                              element['sellRate'] ==
                                                                  conversionData[
                                                                      'sellRate'])) {
                                                            conversionList.add(
                                                                conversionData);
                                                          }

                                                          conversionList.sort((a,
                                                                  b) =>
                                                              b['sellRate']
                                                                  .compareTo(a[
                                                                      'sellRate']));
                                                          print(
                                                              "Sort Lost : $conversionList");
                                                          String
                                                              allResavaDataString =
                                                              conversionList
                                                                  .map((element) =>
                                                                      '{${element['agenName']}, ${element['sellRate']}}')
                                                                  .join(', ');
                                                          allResavaDataString =
                                                              allResavaDataString
                                                                  .replaceAll(
                                                                      '{', '')
                                                                  .replaceAll(
                                                                      '}', '');
                                                          print(
                                                              "Sort String! : $allResavaDataString");

                                                          for (var entry
                                                              in conversionList) {
                                                            var agenName =
                                                                entry[
                                                                    'agenName'];
                                                            var sellRate =
                                                                entry[
                                                                    'sellRate'];

                                                            if (sellRate >
                                                                highestSellRate) {
                                                              highestSellRate =
                                                                  sellRate; // update the highest sell rate if a higher value is found
                                                              maxSellRateAgen =
                                                                  agenName; // update the agenName with the highest sell rate

                                                              print(
                                                                  'loop > name: $agenName');
                                                              print(
                                                                  'loop > rate: $sellRate');
                                                            }

                                                            allAgenNames.add(
                                                                agenName); // เก็บ agenName ลงใน List

                                                            allSellRate
                                                                .add(sellRate);
                                                            List<double>
                                                                sellRateList =
                                                                allSellRate
                                                                    .toList();
                                                            print(
                                                                'Rate: ${sellRateList}');
                                                            sellRateList.sort(
                                                                sellRateComparator);
                                                            String
                                                                allSellRateString =
                                                                sellRateList
                                                                    .join(', ');

                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaAgen_Rate =
                                                                allResavaDataString;

                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaFromCur =
                                                                _fromCurrency!;
                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaToCur =
                                                                _toCurrency!;
                                                            //context.read<ReservationData>().resevaAgency = maxSellRateAgen!; //allAgenNames.join(', ');  // กำหนดค่าทั้งหมดใน List เป็นค่าใหม่ของ resevaAgency
                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaAmount =
                                                                _textEditingController
                                                                    .text;
                                                            //context.read<ReservationData>().resevaRateMoney = highestSellRate.toString(); //allSellRateString;

                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaAgency =
                                                                allAgenNames
                                                                    .join(', ');
                                                            context
                                                                    .read<
                                                                        ReservationData>()
                                                                    .resevaRateMoney =
                                                                allSellRateString;
                                                            context
                                                                .read<
                                                                    ReservationData>()
                                                                .notifyChange();

                                                            print(
                                                                'Agen name Provider: ${context.read<ReservationData>().resevaAgency = allAgenNames.join(', ')}');
                                                            print(
                                                                'Rate Money Provider: ${context.read<ReservationData>().resevaRateMoney = allSellRateString}');
                                                            //print('Sort Name: ${agenNamesList}');
                                                            //print('Sort Rate: ${sellRateList}');
                                                          }

                                                          setState(() {
                                                            showPadding = true;
                                                            _exchangeRate =
                                                                highestSellRate; // เอาค่า sellRate จาก conversionMap
                                                            print(
                                                                'Agen name: $agenName');
                                                            print(
                                                                'Sell rate: $sellRate');

                                                            print(
                                                                'Invalid currency');
                                                          });
                                                        }
                                                      }
                                                    }
                                                  } else {
                                                    print('Invalid JSON data');
                                                  }
                                                }

                                                // print('tttttttttttttttttttttttt: $conversionMap');
                                              }
                                              print(
                                                  'Max sell rate Agen name: $maxSellRateAgen // HighestSell: $highestSellRate');

                                              //log(context.read<ReservationData>().resevaCur);
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Calculate exchange rates',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20),
                                          primary: Colors.black54,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(245, 20, 0, 0),
                                        child: Row(
                                          children: [
                                            FloatingActionButton(
                                              onPressed: () async {
                                                final usersRefUpdate =
                                                    FirebaseFirestore.instance
                                                        .collection('keepUID');
                                                await usersRefUpdate
                                                    .doc("pin")
                                                    .update({'uid': userUID});
                                                print('UID Saved');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailAgency(),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.keyboard_arrow_right,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
