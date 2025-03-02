import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  static Future<void> changeEmail(String email, String password) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? currentEmail = currentUser?.email;

      // Check if the new email is different from the current email
      if (currentEmail != email) {
        // Check the user's password
        bool passwordMatch = await checkPassword(password);
        if (passwordMatch) {
          await currentUser!.updateEmail(email);
          await currentUser.sendEmailVerification();
          print('Email updated and verification email sent.');
        } else {
          print('Incorrect password.');
        }
      } else {
        print('New email is the same as the current email.');
      }
    } catch (error) {
      print('An error occurred while changing email: $error');
    }
  }

  static Future<bool> checkPassword(String password) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser!.email!, password: password);
      await currentUser.reauthenticateWithCredential(credential);
      return true;
    } catch (error) {
      print('An error occurred while checking password: $error');
      return false;
    }
  }
}
