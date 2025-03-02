import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import '../login.dart';

class CreatePinPage extends StatefulWidget {
  @override
  _CreatePinPageState createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  String _pin = '';
  //bool _isLoading = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!.uid;
  final usersRef = FirebaseFirestore.instance.collection('usersPIN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create PIN'),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.blueAccent),
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Create PIN',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            const Text('You can use this PIN to unlock the app..'),
            const Text('Pin length is 6 digits'),
            const SizedBox(height: 60),
            Expanded(
              child: PinCodeWidget(
                minPinLength: 6,
                maxPinLength: 6,
                onChangedPin: (pin) {
                  // check the PIN length and check different PINs with 4,5.. length.
                  if (pin.length == 6) {
                    // PIN length is valid, do something
                    print("Surely");
                  } else {
                    // PIN length is invalid, show an error message
                    print("Bad PIN");
                    // or disable the submit button
                  }
                },
                onEnter: (pin, _) {
                  // Save the entered pin to Firestore.

                  if (pin.length == 6) {
                    usersRef
                        .doc(user)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        // Update the PIN
                        usersRef
                            .doc(user)
                            .update({'pin': pin, 'UID': '$user'}).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PIN Update successfully.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          print("PIN Update successfully.");
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginSuccessPage();
                          }));
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to Update PIN.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        });
                      } else {
                        usersRef
                            .doc(user)
                            .set({'pin': pin, 'UID': '$user'}).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PIN Set successfully.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          print("PIN Set successfully.");
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginSuccessPage();
                          }));
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to Set PIN.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        });
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
