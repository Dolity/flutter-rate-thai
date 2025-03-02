import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Setting/Theme.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/register.dart';
import 'package:testprojectbc/role/SuperAdmin/nav/AdminListPage.dart';
import 'package:testprojectbc/role/SuperAdmin/nav/registerSuperAdmin.dart';
import 'package:testprojectbc/role/admin/nav/loginAdmin.dart';
import 'package:testprojectbc/role/admin/nav/registerAdmin.dart';
import 'package:testprojectbc/role/agency/nav/loginAgency.dart';
import 'package:testprojectbc/role/agency/nav/registerAgency.dart';

import 'loginSuperAdmin.dart';

class HomeSuperAdminPage extends StatefulWidget {
  const HomeSuperAdminPage({super.key});

  @override
  State<HomeSuperAdminPage> createState() => _HomeSuperAdminPage();
}

class _HomeSuperAdminPage extends State<HomeSuperAdminPage> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final authen = FirebaseAuth.instance;
  // String usernameData = FirebaseAuth.instance.currentUser!.email!;
  final PageController _controller = PageController(initialPage: 0);
  final List<String> _tabs = ['1', '2'];
  int _selectedIndex = 0;
  bool isDarkTheme = false;

  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    currentUser = authen.currentUser;
    if (currentUser != null) {
      usernameData = currentUser!.email ?? "";
      userUID = currentUser!.uid;
    }
    _registerFirebaseMessagingToken();
  }

  void _registerFirebaseMessagingToken() {
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');

      final usersRef = FirebaseFirestore.instance.collection('usersPIN');
      usersRef.doc(userUID).update(
        {
          'FCMToken': token,
        },
      );
      print('FCM Token Update On FS: $token');
    }).catchError((error) {
      print('Failed to get FCM token: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersPIN')
            .where('UID', isEqualTo: userUID) //getByUID
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/bgnavHome2.jpg'), // เพิ่มรูปภาพที่ต้องการ
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final bool isAdminStatusTrue = userData['isVerify'] == true;
                final bool isDropOffStatus = userData['DropOffStatus'] == true;
                final bool isCheckAgencyStatus =
                    userData['ConditionCheckAgency'] == true;
                final bool isCheckAdminStatus = userData['isVerify'] == true;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Super Admin",
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
                                  onPressed: () {
                                    authen.signOut().then((value) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
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
                    SizedBox(
                      width: 390,
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  if (details.delta.dx > 0) {
                                    _selectedIndex = (_selectedIndex + 1) %
                                        2; // เปลี่ยนภาพไปยังภาพถัดไปเมื่อลากไปทางขวา
                                  } else if (details.delta.dx < 0) {
                                    _selectedIndex = (_selectedIndex - 1) %
                                        2; // เปลี่ยนภาพไปยังภาพก่อนหน้าเมื่อลากไปทางซ้าย
                                  }
                                  _controller.animateToPage(
                                    _selectedIndex,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              },
                              child: AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: -_selectedIndex *
                                    390, // เลื่อนภาพด้วยการกำหนดตำแหน่งซ้ายที่ติดลบ
                                child: PageView.builder(
                                  controller: _controller,
                                  itemCount: 2,
                                  itemBuilder: (context, index) => ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      index == 0
                                          ? 'assets/srg.png'
                                          : 'assets/sro.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10.0,
                              left: 0.0,
                              right: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index;
                                          _controller.animateToPage(
                                            index,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: 10,
                                        width:
                                            _selectedIndex == index ? 20 : 10,
                                        decoration: BoxDecoration(
                                          color: _selectedIndex == index
                                              ? Colors.black
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(height: 0),
                    SizedBox(
                      height: 170,
                      child: Card(
                        color: const Color.fromARGB(0, 255, 255, 255)
                            .withOpacity(0.8),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        elevation: 8,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: ListTile(
                              // trailing: const Icon(Icons.arrow_forward),
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               RegisterSuperAdminPage()));
                              // },
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              dense: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "สวัสดีคุณ Super Admin",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "${userData['displayName']}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'Register Admin',
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterAdminPage(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.app_registration_rounded),
                                        ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Tooltip(
                                        message: 'Login SuperAdmin',
                                        // child: IconButton(
                                        //   onPressed: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             LoginSuperAdminPage(),
                                        //       ),
                                        //     );
                                        //   },
                                        //   icon: const Icon(Icons.login_rounded),
                                        // ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Tooltip(
                                        message: 'Delete Admin',
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminListPage(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      //Box1
                      height: MediaQuery.of(context).size.height - 490,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
                        color: const Color.fromARGB(0, 255, 255, 255)
                            .withOpacity(0.8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1, // Add a border
                          ),
                        ),
                        elevation: 8, // Add a shadow
                        child: InkWell(
                          onTap: () {
                            // Do something when the ListTile is tapped
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('usersPIN')
                                      .where('role', isEqualTo: 'superadmin')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final usersAgency = snapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: usersAgency.length,
                                      itemBuilder: (context, index) {
                                        final userDataAgency =
                                            usersAgency[index].data()
                                                as Map<String, dynamic>;
                                        final displayNameAgency =
                                            userDataAgency['displayName'];
                                        final roleAgency =
                                            userDataAgency['role'];

                                        return ListTile(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          dense: true,
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 10, 0, 0),
                                                          child: ClipOval(
                                                            child:
                                                                Image.network(
                                                              'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                              fit: BoxFit.cover,
                                                              height: 40,
                                                              width: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              "${displayNameAgency}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    10,
                                                                    45,
                                                                    0),
                                                            child: Text(
                                                              "${roleAgency}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // if (isDropOffStatus)
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  240, 0, 0, 0),
                                                          child: Text(
                                                            "Status",
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade500,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      color: Colors.black,
                                                      thickness: 0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
