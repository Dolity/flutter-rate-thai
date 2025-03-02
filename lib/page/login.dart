import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testprojectbc/Service/WebScrape/testScrape1.dart';
import 'package:testprojectbc/page/Navbar/ForgotPasswordScreen.dart';
import 'package:testprojectbc/page/Navbar/homeNav.dart';
import 'package:testprojectbc/page/Setting/notifyFCM.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/selectCurency.dart';
import 'package:testprojectbc/page/smsFA.dart';
import 'package:testprojectbc/role/SuperAdmin/googleFA_SPAdmin.dart';
import 'package:testprojectbc/role/SuperAdmin/nav/navHelperSuperAdmin.dart';
import 'package:testprojectbc/role/admin/googleFA_Admin.dart';
import 'package:testprojectbc/role/admin/nav/navHelperAdmin.dart';
import 'package:testprojectbc/role/agency/googleFA_Agency.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import '../models/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Setting/Theme.dart';
import 'addPost.dart';
import 'curinfo.dart';
import 'Navbar/loginsuccess.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
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

  @override
  void initState() {
    super.initState();
  }

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
                                                  200,
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
                                                        "Welcome",
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
                                                                  24, 0, 0, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return ForgotPasswordScreen();
                                                              }));
                                                            },
                                                            child: Text(
                                                              "Forgot your password?",
                                                              style: TextStyle(
                                                                fontSize: 16,
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
                                                                      .left,
                                                            ),
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
                                                                              MaterialPageRoute(builder: (context) => GooglefaAgencyPage()),
                                                                            );
                                                                            break;
                                                                          case "admin":
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => GooglefaAdminPage()),
                                                                            );
                                                                            break;
                                                                          case "superadmin":
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => GooglefaSPadminPage()),
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
                                                                              "user",
                                                                          'UID':
                                                                              user.uid,
                                                                          'displayName':
                                                                              keepName,
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
                                                                              builder: (context) => GooglefaPage()),
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
                                                                            "user",
                                                                        'UID': user
                                                                            .uid,
                                                                        'displayName':
                                                                            keepName,
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
                                                                                GooglefaPage()),
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 30, 0, 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'or sign in using',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Lexend',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 0, 0, 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    'facebook');
                                                                loginWithFacebook(
                                                                    context);
                                                              },
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/facebook.png',
                                                                  fit: BoxFit
                                                                      .none,
                                                                  semanticLabel:
                                                                      'image description',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print('google');
                                                                loginWithGoogle(
                                                                    context);
                                                              },
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/google.png',
                                                                  fit: BoxFit
                                                                      .none,
                                                                  semanticLabel:
                                                                      'image description',
                                                                  scale: 1.2,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                                              Navigator.pushReplacementNamed(
                                                                  context,
                                                                  "/register-page",
                                                                  arguments: []);
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
        // scopes: [
        //   'https://www.googleapis.com/auth/contacts.readonly',
        // ],
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
    // await FirebaseFirestore.instance
    //     .collection('usersPIN')
    //     .doc(userDoc!.uid)
    //     .set(userData, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('usersPIN')
        .doc(userDoc!.uid)
        .update({
      'displayName': user.displayName,
      'UID': userDoc.uid,
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return (GooglefaPage());
    })); // after success route to home.
    print('google OK');
    // if (mounted) await _googleSignIn.disconnect();
    // print('google Fail');
  }

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
