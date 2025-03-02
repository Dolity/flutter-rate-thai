import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Reservation/cashCheer.dart';
import 'package:testprojectbc/page/Reservation/debitCard.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/qrCode.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;

class DetailAgency extends StatefulWidget {
  @override
  _DetailAgencyState createState() => _DetailAgencyState();
}

class _DetailAgencyState extends State<DetailAgency> {
  String? _fromAgency = 'BKK';
  String? _fromPay = 'Visa';
  double? maxSellRate = 0.0;
  String? maxSellRateAgen = '';
  var highestSellRate = 0.0;

  bool showPadding = false;
  bool isExpanded = false;
  bool checkStatus = false;
  bool keepStatus = false;
  bool? isVerify;
  bool? isReservation;
  bool? isNotifyLocal = false;

  @override
  Widget build(BuildContext context) {
    String resevaRateMoney = context.watch<ReservationData>().resevaRateMoney;
    List<String> rateList = resevaRateMoney.split(', ');

    String resevaAllData = context.watch<ReservationData>().resevaAgen_Rate;
    List<String> AllDataList = resevaAllData.split(', ');

    for (int i = 0; i < AllDataList.length; i++) {
      String ValueAllData = AllDataList[i];
      print('Rate at index $i: $ValueAllData');
    }

    print("index Rate = : ${rateList.length}");
    print("rate : ${resevaRateMoney}");

    print("index AllData = : ${AllDataList.length}");
    print("AllData : ${resevaAllData}");

    String currentRate1 = "";
    String currentRate2 = "";
    String currentRate3 = "";
    String currentRate4 = "";
    String currentRate5 = "";
    String currentRate6 = "";
    String currentRate7 = "";
    String currentRate8 = "";
    String currentRate9 = "";
    String currentRate10 = "";

    String agentcy1 = "";
    String agentcy2 = "";
    String agentcy3 = "";
    String agentcy4 = "";
    String agentcy5 = "";
    String agentcy6 = "";

    String agentcyUpdate = "";
    String currentRateUpdate = "";

    if (rateList.length == 11) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      print("if >=11 OK");
    }
    if (rateList.length == 10) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      print("if >=10 OK");
    }
    if (rateList.length == 9) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      print("if >=9 OK");
    }
    if (rateList.length == 8) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      print("if >=8 OK");
    }
    if (rateList.length == 7) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      print("if >=7 OK");
    }
    if (rateList.length == 6) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      agentcy6 = AllDataList[10];
      currentRate5 = AllDataList[11];
      ("if >=6 OK");
    }
    if (rateList.length == 5) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      agentcy5 = AllDataList[8];
      currentRate4 = AllDataList[9];
      print("if >=5 OK");
    }
    if (rateList.length == 4) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      agentcy4 = AllDataList[6];
      currentRate3 = AllDataList[7];
      print("if >=4 OK");
    }
    if (rateList.length == 3) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      print("if >=3 OK");
    }
    if (rateList.length == 2) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      print("if >=2 OK");
    }
    if (rateList.length == 1) {
      agentcy1 = AllDataList[0];
      currentRate1 = AllDataList[1];
      agentcy2 = AllDataList[2];
      currentRate2 = AllDataList[3];
      agentcy3 = AllDataList[4];
      currentRate3 = AllDataList[5];
      print("if >=1 OK");
    }

    TextEditingController dateController = TextEditingController();
    TextEditingController agencyController = TextEditingController();
    TextEditingController payController = TextEditingController();

    List<String> subAgency = [
      'BKK',
      'CBI',
      'CMI',
      'KKN',
      'MKM',
      'NMA',
      'PBI',
      'PKT',
      'PRE',
      'RYG',
      'UBN',
      'UDN'
    ];

    List<String> payMethod = [
      'Visa',
      'QR Code',
      'Cash Cheer',
    ];

    final user = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final data1 = usersRef.doc(user).get();
    // context.read<ReservationData>().getUID = user;

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

    // Function to show the AlertDialog
    void showCustomDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Variables to store the selected values
          String selectedDatePre = '';
          String selectedDate = '';

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            ),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reservation currency process',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your select: 1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRateUpdate} THB By ${agentcyUpdate}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              );

                              if (pickedDate != null) {
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  final DateTime selectedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                  setState(() {
                                    final DateFormat formatter =
                                        DateFormat('yyyy-MM-dd HH:mm');
                                    selectedDatePre =
                                        formatter.format(selectedDateTime);
                                    dateController.text = selectedDatePre;
                                    selectedDate = selectedDatePre;
                                  });
                                }
                              }
                            },
                            child: IgnorePointer(
                              child: TextField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  hintText: selectedDate.isNotEmpty
                                      ? selectedDate
                                      : 'Select date to pickup money',
                                  prefixIcon:
                                      Icon(Icons.calendar_today_outlined),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _fromAgency,
                            onChanged: (value) {
                              setState(() {
                                _fromAgency = value;
                              });
                            },
                            items: subAgency
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _fromPay,
                            onChanged: (value) {
                              setState(() {
                                _fromPay = value;
                              });
                            },
                            items: payMethod
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          globals.globalUID = user;

                          final usersRefUpdate =
                              FirebaseFirestore.instance.collection('keepUID');
                          await usersRefUpdate.doc("pin").update({'uid': user});
                          print('UID on Pin Saved');

                          print('Selected Date: $selectedDate');
                          print('Selected Sub-Agency: $_fromAgency');
                          print('Selected Payment: $_fromPay');
                          final DocumentSnapshot<Map<String, dynamic>>
                              snapshot = await data1;

                          if (snapshot.data()!['DateReserva'] != null ||
                              snapshot.data()!['DateReserva'] == null) {
                            print('Updage data');
                            usersRef.doc(user).update({
                              'UID': '$user',
                              'DateReserva': '$selectedDate',
                              'SubAgencyReserva': '$_fromAgency',
                              'PayReserva': '$_fromPay',
                              'ReservationStatus': checkStatus,
                              'ConditionCheckAgency': keepStatus,
                              'ConditionQR': 'true',
                              'AgencyReserva': agentcyUpdate,
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Save to reservation on FireStoreSuccess! (Update)'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Failed to save reservation on FireStoreSuccess!! (Update)'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });

                            // เพิ่มค่าเข้าไปใน array ในฐานข้อมูล
                            usersRef.doc(user).update({
                              'AgencyArr':
                                  FieldValue.arrayUnion([agentcyUpdate]),
                            });

                            // // ข้อมูลที่ต้องการเก็บ
                            var reservationData = {
                              // 'UID': '$user',
                              'DateReservaArr': '$selectedDate',
                              'SubAgencyReservaArr': '$_fromAgency',
                              'PayReservaArr': '$_fromPay',
                              'ReservationStatusArr': checkStatus,
                              'ConditionCheckAgencyArr': keepStatus,
                              'ConditionQRArr': 'true',
                              'AgencyReservaArr': agentcyUpdate,
                              'isNotifyLocal': isNotifyLocal,
                            };
                            // อัปเดตข้อมูลในฟิลด์ reservations โดยเพิ่มข้อมูลใหม่ลงใน List ตัวเดิม
                            usersRef.doc(user).update({
                              'ReservationArr':
                                  FieldValue.arrayUnion([reservationData]),
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Save to reservation on Firestore Success! (Update)'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Failed to save reservation on Firestore! (Update)'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                          }
                          if (_fromPay == 'Visa') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PayDebitCardPage(),
                              ),
                            );
                          } else if (_fromPay == 'QR Code') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PayQRCodePage(),
                              ),
                            );
                          } else if (_fromPay == 'Cash Cheer') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PayCashCheerPage(),
                              ),
                            );
                          }
                        },
                        child: Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: [],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: 0.50, // ค่าความคืบหน้า 25%
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // if (showPadding)
                //////////////////////////////////// Agency 1 ////////////////////////////////////
                if (currentRate1.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate1;
                      agentcyUpdate = agentcy1;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: isExpanded ? 200 : 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy1 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy1 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy1 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy1 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy1 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy1 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy1 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 20, 0, 0),
                                      child: Text(
                                        'This agency best exchange rates!',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                      child: Text(
                                        '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate1} THB',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

//////////////////////////////////// Agency 2 ////////////////////////////////////
                if (currentRate2.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate2;
                      agentcyUpdate = agentcy2;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy2 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy2 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy2 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy2 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy2 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy2 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy2 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 0, 0),
                                        child: Text(
                                          'This agency second choice!',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate2} THB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

//////////////////////////////////// Agency 3 ////////////////////////////////////
                if (currentRate3.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate3;
                      agentcyUpdate = agentcy3;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy3 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy3 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy3 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy3 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy3 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy3 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy3 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 0, 0),
                                        child: Text(
                                          'This agency third choice!',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate3} THB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

//////////////////////////////////// Agency 4 ////////////////////////////////////
                if (currentRate4.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate4;
                      agentcyUpdate = agentcy4;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy4 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy4 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy4 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy4 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy4 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy4 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy4 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 0, 0),
                                        child: Text(
                                          'This agency fourth choice!',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate4} THB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

//////////////////////////////////// Agency 5 ////////////////////////////////////
                if (currentRate5.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate5;
                      agentcyUpdate = agentcy5;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy5 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy5 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy5 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy5 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy5 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy5 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy5 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 0, 0),
                                        child: Text(
                                          'This agency fifth choice!',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate5} THB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

//////////////////////////////////// Agency 6 ////////////////////////////////////
                if (currentRate6.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      currentRateUpdate = currentRate6;
                      agentcyUpdate = agentcy6;
                      context.read<ReservationData>().resevaProviAgencyUpdate =
                          agentcyUpdate;
                      context.read<ReservationData>().resevaProviRateUpdate =
                          currentRateUpdate;
                      showCustomDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          //Box1
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            // Shows the largest companies and currencies.
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                if (context
                                            .watch<ReservationData>()
                                            .resevaAgency
                                            .toString() !=
                                        null &&
                                    context
                                            .watch<ReservationData>()
                                            .resevaRateMoney
                                            .toString() !=
                                        null)
                                  if (agentcy6 == 'SRO')
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                      width: 130,
                                      height: 130,
                                    ),
                                if (agentcy6 == 'SRG')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy6 == 'VPC')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy6 == 'K79')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy6 == 'SME')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy6 == 'VSU')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                    width: 130,
                                    height: 130,
                                  ),
                                if (agentcy6 == 'XNE')
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                    width: 130,
                                    height: 130,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 0, 0),
                                        child: Text(
                                          'This agency sixth choice!',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          '1 ${context.watch<ReservationData>().resevaFromCur.toString()} = ${currentRate6} THB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
