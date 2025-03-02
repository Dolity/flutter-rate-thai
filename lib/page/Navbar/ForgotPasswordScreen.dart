import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../Setting/Theme.dart';
import '../Setting/forgotPW.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void _resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;

    try {
      await resetPassword(email, oldPassword, newPassword);
      print("เปลี่ยนรหัสผ่านสำเร็จ");
      emailController.clear();
      oldPasswordController.clear();
      newPasswordController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Your password has been successfully changed.'),
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
    } catch (e) {
      print("Error changing password: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error changing password: $e'),
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
    }
  }

  Future<void> resetPassword(
      String email, String oldPassword, String newPassword) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await userCredential.user?.updatePassword(newPassword);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData =
        Styles.themeData(false, context); // ใช้สไตล์จาก Styles

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
        ),
        backgroundColor: themeData.appBarTheme.backgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: themeData.cardColor,
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: themeData.colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        prefixIcon: Icon(
                          Ionicons.mail_open_outline,
                          color: Colors.grey,
                        ),
                        hintText: "Email",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: oldPasswordController,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: themeData.colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        prefixIcon: Icon(
                          Ionicons.lock_open_outline,
                          color: Colors.grey,
                        ),
                        hintText: "Old Passwod",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: newPasswordController,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: themeData.colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        prefixIcon: Icon(
                          Ionicons.lock_closed_outline,
                          color: Colors.grey,
                        ),
                        hintText: "New Passwod",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600, color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 13),
                          primary: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        // style: ButtonStyle(
                        //   backgroundColor: MaterialStateProperty.all<Color>(
                        //     themeData.colorScheme.primary,
                        //   ),
                        // ),
                        onPressed: () => _resetPassword(context),
                        child: Text(
                          'Save',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
