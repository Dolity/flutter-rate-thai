import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testprojectbc/Service/Constants/constants.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'dart:async';

class GooglefaPage extends StatefulWidget {
  // final String userPIN;
  // GooglefaPage({required this.userPIN});

  @override
  State<StatefulWidget> createState() {
    return _GooglefaPage();
  }
}

class _GooglefaPage extends State<GooglefaPage> {
  // final String _authKeySecret = base32.encodeString('jakkrit');
  String? _currentCode;
  String? title;

  bool light = true;
  bool verifyResult = false;

  TextEditingController text2faController = TextEditingController();

  final userPIN = FirebaseAuth.instance.currentUser!.uid;
  String mySecret = secret!;
  late final String _authKeySecret;
  late SharedPreferences _preferences;
  bool? checkTOTPStatus = false;

  Future<String> fetchMySecret() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usersPIN')
        .doc(userPIN)
        .get();
    if (snapshot.exists) {
      checkTOTPStatus = snapshot.data()!['ConditionCheckTOTP'];
      return snapshot.data()!['displayName'];
    }
    return '';
  }

  Future<void> totpCheck() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(userPIN).get();

    if (snapshot.exists) {
      setState(() {
        checkTOTPStatus = true;
      });

      if (snapshot.data()!['DateReserva'] != null ||
          snapshot.data()!['DateReserva'] == null) {
        usersRef.doc(userPIN).update({
          'ConditionCheckTOTP': checkTOTPStatus,
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

  Future<void> _saveTOTPSession(bool success) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await _preferences.setInt('totp_last_success_time', currentTime);
    await _preferences.setBool('totp_verification_success', success);
  }

  void _resetTOTPSession() async {
    await _saveTOTPSession(false);
  }

  Future<bool> _checkTOTPSession() async {
    final lastSuccessTime = _preferences.getInt('totp_last_success_time') ?? 0;
    final verificationSuccess =
        _preferences.getBool('totp_verification_success') ?? false;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final difference = currentTime - lastSuccessTime;
    return verificationSuccess &&
        difference <= (5 * 60 * 1000); // 5 minutes in milliseconds
  }

  @override
  void initState() {
    super.initState();
    fetchMySecret().then(
      (secret) async {
        setState(() {
          mySecret = secret;
          _authKeySecret = base32.encodeString(mySecret);
          print('mySecret FS inti: $mySecret');
        });
        // _preferences = await SharedPreferences.getInstance();
        // bool isTOTPSessionValid = await _checkTOTPSession();
        // // เรียกใช้งานเพื่อตรวจสอบสถานะ TOTP session
        // if (_preferences == null) {
        //   // ผู้ใช้ใหม่
        //   print('New User');
        // } else {
        //   // ผู้ใช้เก่า
        //   print('Existing User');
        //   if (isTOTPSessionValid) {
        //     print('Old User');
        //     Navigator.pushReplacementNamed(context, "/loginsuccess-page",
        //         arguments: []);
        //   }
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2FA"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(Constants.otpGifImage),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Authenticator',
                style: TextStyle(
                  fontSize: 34,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    borderRadius: BorderRadius.circular(30),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  controller: text2faController,
                  onCompleted: (v) {
                    debugPrint("Completed All Fill");
                  },
                  onChanged: (value) async {
                    int currentTime = DateTime.now().millisecondsSinceEpoch;
                    var timedCode = OTP.generateTOTPCodeString(
                      _authKeySecret,
                      currentTime,
                      length: 6,
                      interval: 30,
                      algorithm: Algorithm
                          .SHA1, // PLEASE change this from default/ suggested SHA1 which is a lot less secure
                      isGoogle: true,
                    );
                    setState(() {
                      _currentCode = timedCode;
                    });

                    if (value.length == 6) {
                      var secret = base32.encodeString(mySecret);
                      var verify =
                          OTP.constantTimeVerification(timedCode, value);
                      FirebaseFirestore.instance
                          .collection('usersPIN')
                          .doc(userPIN)
                          .get()
                          .then((snapshot) async {
                        print('verify: $verify');
                        if (snapshot.exists) {
                          // String timedCode = generateTOTP(mySecret, 6, 30);
                          print('value press: $mySecret');
                          print('timeCode: $timedCode');

                          if (verify) {
                            print('verify TRUE');

                            totpCheck();
                            Navigator.pushReplacementNamed(
                                context, "/loginsuccess-page",
                                arguments: []);
                            Fluttertoast.showToast(
                              msg: 'TOTP Pass ✅',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                            );
                            await _saveTOTPSession(true);
                          } else {
                            print('verify False');
                            // TOTP ไม่ถูกต้อง
                            setState(() {
                              text2faController.clear();
                              verifyResult = true;
                            });
                            Fluttertoast.showToast(
                              msg: 'TOTP Wrong ❌',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                            );
                            await _saveTOTPSession(false);
                          }
                        }
                      });
                    }
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
              ),
              (verifyResult) ? Text("Not pass!") : Container(),
              if (checkTOTPStatus == null || checkTOTPStatus == false)
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Scan TOTP Auth',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final String otpauthLink =
                                  'otpauth://totp/RateThai?secret=$mySecret&issuer=$mySecret';
                              print('onPressed: $mySecret');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Genarate TOTP'),
                                    content: Container(
                                      height: 480,
                                      padding: EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          BarcodeWidget(
                                            width: 320,
                                            height: 320,
                                            data:
                                                "otpauth://totp/RateThai?secret=" +
                                                    base32.encodeString(
                                                        mySecret) +
                                                    "&issuer=$mySecret",
                                            barcode: Barcode.qrCode(),
                                          ),
                                          Text(
                                            'Please add the following TOTP manually to your Google Authenticator app:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SelectableText(
                                              'Acc Name: $mySecret \nKey: $_authKeySecret'),
                                          // Text('Acc Name: $mySecret'),
                                          // Text('Key: $_currentCode')
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              print('GenQR: $mySecret');
                              // print('otpauthLink: $otpauthLink');
                            },
                            child: Text('Scan QR Code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
