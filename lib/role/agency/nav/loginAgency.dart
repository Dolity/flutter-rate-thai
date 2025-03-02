import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testprojectbc/models/profile.dart';
import 'package:testprojectbc/page/Navbar/homeNav.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/selectCurency.dart';
import 'package:testprojectbc/page/smsFA.dart';
import 'package:testprojectbc/role/admin/nav/navHelperAdmin.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:testprojectbc/role/agency/nav/registerAgency.dart';

// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

class LoginAgencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginAgencyPage();
  }
}

class _LoginAgencyPage extends State<LoginAgencyPage> {
  // DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  bool isDarkTheme = false;
  bool value = false;
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final fb = FacebookLogin();

  var loading = false;

  final db = FirebaseFirestore.instance;

  late final String displayName;

  final usersRef = FirebaseFirestore.instance.collection('usersPIN');

  bool valueObscureText = true;
  // Add a list of company names
  List<String> companyNames = [
    "K79",
    "VPC",
    "SME",
    "XNE",
    "SRG",
    "VSU",
    "SRO",
  ];

  String selectedCompanyName = "K79"; // Default selected company

  @override
  Widget build(BuildContext context) {
    isDarkTheme = isDarkTheme;
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          // if (snapshot.connectionState == ConnectionState.done)

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: Image.asset(
                            'assets/bgHome2.jpg',
                          ).image,
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return Card(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 50,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  0, 255, 255, 255),
                                              width: 1,
                                            ),
                                          ),
                                          elevation: 8,
                                          color:
                                              Color.fromARGB(0, 255, 255, 255)
                                                  .withOpacity(0.8),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              // height: MediaQuery.of(context)
                                              //     .size
                                              //     .height,
                                              // height: 450,
                                              height: MediaQuery.sizeOf(context)
                                                      .height -
                                                  320,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(24, 24,
                                                                  0, 20),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.asset(
                                                            'assets/LG_RT.png',
                                                            width: 170,
                                                            height: 60,
                                                            scale: 0.8,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              24, 10, 0, 0),
                                                      child: Text(
                                                        "Welcome Agency",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 34,
                                                          fontFamily: 'Lexend',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              24, 5, 0, 0),
                                                      child: Text(
                                                        "Login to access your account below.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        // style: Theme.of(context).textTheme.headlineSmall,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Lexend',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(40, 20,
                                                                  40, 0),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        onSaved:
                                                            (String? email) {
                                                          profile.email = email;
                                                        },
                                                        validator:
                                                            MultiValidator([
                                                          RequiredValidator(
                                                              errorText:
                                                                  "Please enter email!"),
                                                          EmailValidator(
                                                              errorText:
                                                                  "email formation not correct!")
                                                        ]),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Email',
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.email_rounded,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        controller:
                                                            _usernameController,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(40, 20,
                                                                  40, 20),
                                                      child: TextFormField(
                                                        onSaved:
                                                            (String? password) {
                                                          profile.password =
                                                              password;
                                                        },
                                                        validator:
                                                            RequiredValidator(
                                                                errorText:
                                                                    "Please enter password!"),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        obscureText:
                                                            valueObscureText,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Password',
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .password_rounded,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          suffixIcon: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                valueObscureText =
                                                                    !valueObscureText;
                                                              });
                                                            },
                                                            child: Icon(
                                                              valueObscureText
                                                                  ? Icons
                                                                      .visibility_off
                                                                  : Icons
                                                                      .visibility,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                        controller:
                                                            _passwordController,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  100, 0, 0, 0),
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedCompanyName,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedCompanyName =
                                                                    newValue!;
                                                              });

                                                              print(
                                                                  'click $selectedCompanyName');
                                                            },
                                                            items: companyNames
                                                                .map((String
                                                                    value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Lexend',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 24, 0),
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Theme.of(
                                                                              context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              onPrimary: Theme.of(
                                                                              context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fixedSize:
                                                                  const Size(
                                                                      120, 45),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                formKey
                                                                    .currentState
                                                                    ?.save();
                                                                print(
                                                                    "email = ${profile.email}, password = ${profile.password}");
                                                                try {
                                                                  final authResult =
                                                                      await FirebaseAuth
                                                                          .instance
                                                                          .signInWithEmailAndPassword(
                                                                    email: profile
                                                                        .email!,
                                                                    password:
                                                                        profile
                                                                            .password!,
                                                                  );
                                                                  final user =
                                                                      authResult
                                                                          .user;
                                                                  String?
                                                                      keepName =
                                                                      profile
                                                                          .email;
                                                                  print(
                                                                      'DisplayName: $keepName');
                                                                  formKey
                                                                      .currentState!
                                                                      .reset();
                                                                  if (user !=
                                                                      null) {
                                                                    print(
                                                                        'user have data');
                                                                    final userDoc = await usersRef
                                                                        .doc(user
                                                                            .uid)
                                                                        .get();

                                                                    if (userDoc
                                                                        .exists) {
                                                                      print(
                                                                          'userDoc have exists');
                                                                      final data = userDoc
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>?;

                                                                      if (data !=
                                                                              null &&
                                                                          data.containsKey(
                                                                              'role')) {
                                                                        print(
                                                                            'condition[role]');
                                                                        String
                                                                            role =
                                                                            data['role'];
                                                                        switch (
                                                                            role) {
                                                                          case "user":
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => GooglefaPage()),
                                                                            );
                                                                            break;
                                                                          case "agency":
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => NavHleperAgencyPage()),
                                                                            );
                                                                            break;
                                                                          case "admin":
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => NavHleperAdminPage()),
                                                                            );
                                                                            break;
                                                                          default:
                                                                            Fluttertoast.showToast(
                                                                              msg: "Error Can't Authorize!",
                                                                              gravity: ToastGravity.CENTER,
                                                                            );
                                                                            print("Error Can't Authorize!");
                                                                            break;
                                                                        }
                                                                      } else {
                                                                        print(
                                                                            'conditionCrateROLE');
                                                                        await usersRef
                                                                            .doc(user.uid)
                                                                            .update({
                                                                          'role':
                                                                              "agency",
                                                                          'UID':
                                                                              user.uid,
                                                                          'displayName':
                                                                              keepName,
                                                                          'agency':
                                                                              selectedCompanyName
                                                                        });
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Text('Save to Status on Firestore Success! (Update)'),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ),
                                                                        );
                                                                        Navigator
                                                                            .pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => NavHleperAgencyPage()),
                                                                        );
                                                                      }
                                                                    } else {
                                                                      print(
                                                                          'userDocNot.exists');
                                                                      await usersRef
                                                                          .doc(user
                                                                              .uid)
                                                                          .set({
                                                                        'role':
                                                                            "agency",
                                                                        'UID': user
                                                                            .uid,
                                                                        'displayName':
                                                                            keepName,
                                                                        'agency':
                                                                            selectedCompanyName
                                                                      });
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Save to Status on Firestore Success! (Update)'),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ),
                                                                      );
                                                                      Navigator
                                                                          .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                NavHleperAgencyPage()),
                                                                      );
                                                                    }
                                                                  }
                                                                } on FirebaseAuthException catch (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: e
                                                                        .message!,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .CENTER,
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: Text(
                                                              'Login',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Lexend',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Don\'t have an account?',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'YourFontFamily',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  24, 0, 4, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return RegisterAgencyPage();
                                                              }));
                                                            },
                                                            child: Text(
                                                              'Create',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Lexend',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          color: Colors.blue,
                                                          size: 24,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user!.authentication;

    final authResult = await FirebaseAuth.instance
        .signInWithCredential(GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    ));

    print(user);

    final userDoc = authResult.user;
    Map<String, dynamic> userData = {
      'displayName': user.displayName,
      // เพิ่มข้อมูลอื่นๆ ที่คุณต้องการเก็บได้ตามต้องการ
    };
    await FirebaseFirestore.instance
        .collection('usersPIN')
        .doc(userDoc!.uid)
        .set(userData, SetOptions(merge: true));

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return (GooglefaPage());
    })); // after success route to home.
  }

  // Future<void> saveUser(GoogleSignInAccount account) async {
  //   FirebaseFirestore.instance.collection("Users").doc(account.email).set({
  //     "email": account.email,
  //     "name": account.displayName,
  //     "profilepic": account.photoUrl
  //   });
  //   print("Saved User data");
  // }

  Future loginWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await _auth.signInWithCredential(facebookAuthCredential);

      print(loginResult);

      // Get the currently logged in user
      User? user = _auth.currentUser;

      if (user != null) {
        Map<String, dynamic> userData = {
          'displayName': user.displayName,
          // เพิ่มข้อมูลอื่นๆ ที่คุณต้องการเก็บได้ตามต้องการ
        };

        await FirebaseFirestore.instance
            .collection('usersPIN')
            .doc(user.uid)
            .set(
              userData,
              SetOptions(merge: true),
            );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.CENTER
          // backgroundColor: Colors.blueGrey);
          );
    }

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return GooglefaPage();
    }));
  }
}
