import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../Setting/changeEP.dart';

class changeEmailNav extends StatefulWidget {
  const changeEmailNav({super.key});

  @override
  State<changeEmailNav> createState() => _changeEmailNavState();
}

class _changeEmailNavState extends State<changeEmailNav> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: themeData.cardColor,
        ),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      'Reset Email',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        prefixIcon: Icon(
                          Ionicons.mail_outline,
                          color: Colors.grey,
                        ),
                        hintText: "New Email",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600, color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        prefixIcon: Icon(
                          Ionicons.lock_closed_outline,
                          color: Colors.grey,
                        ),
                        hintText: "Password",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600, color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  await UserManagement.changeEmail(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Alert'),
                                        content: Text(
                                            'Your password has been successfully changed.'),
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
                                  _emailController.clear();
                                  _passwordController.clear();
                                }
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content:
                                          Text('Error changing password: $e'),
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
                            },
                            // style: ButtonStyle(
                            //   backgroundColor: MaterialStateProperty.all<Color>(
                            //     themeData.colorScheme.primary,
                            //   ),
                            // ),

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
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
