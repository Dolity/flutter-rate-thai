import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/models/profile.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/role/agency/nav/loginAgency.dart';

// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
// import 'lib.google_fonts.dart';

class RegisterAgencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterAgencyPage();
  }
}

class _RegisterAgencyPage extends State<RegisterAgencyPage> {
  bool value = false;
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  TextEditingController? emailInputController;
  TextEditingController? passwordInputController;
  TextEditingController? repassInputController;

  bool valueObscureText = true;

  @override
  void initState() {
    super.initState();
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
    repassInputController = TextEditingController();
  }

  @override
  void dispose() {
    emailInputController?.dispose();
    passwordInputController?.dispose();
    repassInputController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).backgroundColor,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: Image.asset(
                            'assets/bgHome2.jpg',
                          ).image,
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 60,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(
                            color: Color.fromARGB(0, 255, 255, 255),
                            width: 1,
                          ),
                        ),
                        elevation: 8,
                        color:
                            Color.fromARGB(0, 255, 255, 255).withOpacity(0.8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 40, 0, 0),
                                    child: Image.asset(
                                      'assets/LG_RT.png',
                                      width: 170,
                                      height: 60,
                                      scale: 0.8,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(24, 20, 0, 0),
                                    child: Text(
                                      "Get Started Below.",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(70, 20, 0, 0),
                                    child: Text(
                                      "For Agency.",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 15, 15, 15),
                                      child: TextFormField(
                                        // key: formKey,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (String? email) {
                                          profile.email = email;
                                        },
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Please enter email!"),
                                          EmailValidator(
                                              errorText:
                                                  "email formation not correct!")
                                        ]),

                                        controller: emailInputController,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          hintText: 'Enter your email here ...',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_rounded,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 15, 15, 15),
                                      child: TextFormField(
                                        // key: formKey,
                                        onSaved: (String? password) {
                                          profile.password = password;
                                        },
                                        validator: RequiredValidator(
                                            errorText:
                                                "Please enter password!"),

                                        controller: passwordInputController,
                                        //maxLines: null,

                                        textAlign: TextAlign.center,
                                        obscureText: valueObscureText,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          hintText:
                                              'Enter your password here ...',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.password_rounded,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
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
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 15, 15, 15),
                                      child: TextFormField(
                                        // key: formKey,
                                        // onSaved: (String? password) {
                                        //   profile.password = password;
                                        // },
                                        validator: RequiredValidator(
                                            errorText:
                                                "Please Re-enter password!"),

                                        controller: repassInputController,
                                        textAlign: TextAlign.center,
                                        obscureText: valueObscureText,
                                        decoration: InputDecoration(
                                          labelText: 'Re-Password',
                                          hintText:
                                              'Enter your re-password here ...',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.password_rounded,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
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
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        // fontFamily: 'Lexend Deca',
                                        // color: Color(0xFF1D2429),
                                        // fontSize: 14,
                                        // fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 30, 15, 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              onPrimary: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.black,
                                              fixedSize: const Size(200, 45),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState?.save();
                                                print(
                                                    "email = ${profile.email}, password = ${profile.password}");
                                                try {
                                                  await FirebaseAuth.instance
                                                      .createUserWithEmailAndPassword(
                                                          email: profile.email!,
                                                          password:
                                                              profile.password!)
                                                      .then((value) {
                                                    formKey.currentState
                                                        ?.reset();
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Create account success",
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      // backgroundColor: Colors.blueGrey
                                                    );
                                                    if (!mounted) return;
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return LoginAgencyPage();
                                                    }));
                                                  });
                                                } on FirebaseAuthException catch (e) {
                                                  // print(e);
                                                  // print(e.languageCode);

                                                  Fluttertoast.showToast(
                                                    msg: e.message!,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    // backgroundColor: Colors.blueGrey
                                                  );
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Crate Account',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                            // icon: Icon(Icons.navigate_next),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Already have an account?',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'YourFontFamily',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(24, 0, 4, 0),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return LoginAgencyPage();
                                              }));
                                            },
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
}
