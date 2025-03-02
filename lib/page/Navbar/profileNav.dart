import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/getBalance.dart';
import 'package:testprojectbc/page/Setting/getQR.dart';
import 'package:testprojectbc/page/Setting/havePin.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import 'package:testprojectbc/screen/testBlockchainUser.dart';
import '../Setting/makePin.dart';
import '../otpsuccess.dart';
import '../Setting/Theme.dart';
import '../Navbar/ChangeEmailScreen.dart';
import '../Navbar/ForgotPasswordScreen.dart';

class ProfileNav extends StatefulWidget {
  @override
  _ProfileNav createState() => _ProfileNav();
}

class _ProfileNav extends State<ProfileNav> {
  bool _notificationEnabled = true;
  String _username = 'John Doe';

  void _toggleNotification(bool value) {
    setState(() {
      _notificationEnabled = value;
    });
  }

  Future<void> _editUsername() async {
    String? newUsername = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController =
            TextEditingController(text: _username);
        return AlertDialog(
          title: const Text('Edit username'),
          content: TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(usernameController.text);
              },
            ),
          ],
        );
      },
    );

    if (newUsername != null && newUsername.isNotEmpty) {
      setState(() {
        _username = newUsername;
      });
    }
  }

  void _editPin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePinPage()));
  }

  void _openHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Steps & Flow to use the application'),
          content: Container(
            height: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. Verify KYC'),
                const Text('2. Create PIN'),
                const Text('3. Await Identity Verification'),
                const Text('4. Select Currency for Reservation and Proceed'),
                const Text('5. Await Reservation Confirmation'),
                const Text(
                    '6. Scan the QR CODE at the Company\'s Branch in the Selected Province'),
                const Text(
                    '7. Await Fund Release Confirmation, Process Completed'),
                SizedBox(
                  height: 20,
                ),
                const Text('1. ยืนยันตัวตน KYC'),
                const Text('2. สร้างรหัส PIN'),
                const Text('3. รอการยืนยันตัวตน'),
                const Text('4. เลือกสกุลเงินที่ต้องการจองและทำไปตามลำดับ'),
                const Text('5. รอการยืนยันการจองสกุลเงิน'),
                const Text(
                    '6. นำ QR CODE มาสแกนที่บริษัทตามสาขาประจำจังหวัดที่เลือก'),
                const Text('7. รอการยืนยันปล่อยเงิน เสร็จสิ้นขั้นตอน'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeEmail() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const changeEmailNav()));
  }

  void _forgotPassword() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }

  void verifyQR() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HavePinPage()));
  }

  void checkGetBalance() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GetBalancePage()));
  }

  void checkVerification() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VerificationPage()));
  }

  void historyReservation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => testBCUser()));
  }

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  late String userUID;
  bool? isEmail;
  bool? isGoogle;
  bool? isFacebook;
  final providerData = FirebaseAuth.instance.currentUser?.providerData;

  @override
  void initState() {
    super.initState();
    currentUser = authen.currentUser;
    if (currentUser != null) {
      userUID = currentUser!.uid;
    }
    // final providerData = FirebaseAuth.instance.currentUser?.providerData;

    if (providerData != null && providerData!.isNotEmpty) {
      for (final provider in providerData!) {
        if (provider.providerId == 'password') {
          // ล็อกอินด้วยอีเมล์และรหัสผ่าน
          // ทำสิ่งที่คุณต้องการในกรณีนี้
          isEmail = true;

          print('login Email ${provider.providerId}');
        } else if (provider.providerId == 'google.com') {
          // ล็อกอินด้วย Google
          // ทำสิ่งที่คุณต้องการในกรณีนี้
          isGoogle = true;
          print('login Google ${provider.providerId}');
        } else if (provider.providerId == 'facebook.com') {
          // ล็อกอินด้วย Facebook
          // ทำสิ่งที่คุณต้องการในกรณีนี้
          isFacebook = true;
          print('login Facebook ${provider.providerId}');
        }
      }
    }
    isEmail = false;
    isGoogle = false;
    isFacebook = false;
  }

  final IconData _iconLight = Icons.wb_sunny;
  final IconData _iconDark = Icons.nights_stay;
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (BuildContext context, themeChangeProvider, Widget? child) {
      return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usersPIN')
              .where('UID', isEqualTo: userUID) //getByUID
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = snapshot.data!.docs;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/bgnavHelp1.jpg'), // เพิ่มรูปภาพที่ต้องการ
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData =
                        users[index].data() as Map<String, dynamic>;
                    final bool isAdminStatusTrue = userData['isVerify'] == true;

                    List<Widget> children =
                        []; // สร้างรายการของวิดเจ็ตในรายการ ListTile

                    children.add(
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Setting",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                // onTap: () {
                                //   print('google');
                                //   loginWithGoogle(context);
                                // },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.logout),
                                    onPressed: () async {
                                      authen.signOut().then((value) async {
                                        // final providerData = FirebaseAuth
                                        //     .instance.currentUser?.providerData;
                                        for (final provider in providerData!) {
                                          if (provider.providerId ==
                                                  'password' ||
                                              isEmail == true) {
                                            // ล็อกอินด้วยอีเมล์และรหัสผ่าน
                                            // ทำสิ่งที่คุณต้องการในกรณีนี้
                                            // providerData!.clear();
                                            print(
                                                'login Out ${provider.providerId}');
                                          } else if (provider.providerId ==
                                                  'google.com' ||
                                              isGoogle == true) {
                                            // ล็อกอินด้วย Google
                                            // ทำสิ่งที่คุณต้องการในกรณีนี้
                                            // providerData!.clear();
                                            await GoogleSignIn().disconnect();
                                            print(
                                                'login Out ${provider.providerId}');
                                          } else if (provider.providerId ==
                                                  'facebook.com' ||
                                              isFacebook == true) {
                                            // ล็อกอินด้วย Facebook
                                            // ทำสิ่งที่คุณต้องการในกรณีนี้
                                            // await authen.signOut();
                                            // await authen.signInWithCredential(credential);
                                            // providerData!.clear();
                                            print(
                                                'login Out ${provider.providerId}');
                                          }
                                        }
                                        providerData!.clear();

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return LoginPage();
                                        }));
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    // ตรวจสอบ isAdminStatusTrue และเพิ่มรายการ ListTile ที่เกี่ยวข้อง
                    if (isAdminStatusTrue) {
                      children.add(
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "${userData['FirstName']} ${userData['LastName']} ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            // _editPin();
                          },
                        ),
                      );
                    } else {
                      children.add(
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "Plsease Verify KYC ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            // _editPin();
                          },
                        ),
                      );
                    }

                    children.addAll([
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.verified_rounded),
                        title: const Text(
                          'Verity KYC',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          checkVerification();
                        },
                      ),
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.qr_code_2),
                        title: const Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          verifyQR();
                        },
                      ),
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.history),
                        title: const Text(
                          'History Reservation',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          historyReservation();
                        },
                      ),
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.mail_rounded),
                        title: const Text(
                          'Forgot Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          changeEmail();
                        },
                      ),

                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.password),
                        title: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          _forgotPassword();
                        },
                      ),
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.pin),
                        title: const Text(
                          'Forgot PIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          _editPin();
                        },
                      ),
                      // Divider(color: Colors.black),
                      // ListTile(
                      //   title: const Text('Check Blockchain'),
                      //   onTap: () {
                      //     checkGetBalance();
                      //   },
                      // ),
                      Divider(color: Colors.black),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: const Text(
                          'Help',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          _openHelp();
                        },
                      ),
                      Divider(color: Colors.black),
                    ]);

                    return Column(
                        children:
                            children); // ส่งกลับรายการ ListTile ที่สร้างไว้
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
