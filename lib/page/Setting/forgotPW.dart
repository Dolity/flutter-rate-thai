import 'package:firebase_auth/firebase_auth.dart';

Future<void> resetPassword(
    String email, String oldPassword, String newPassword) async {
  try {
    // ล็อกอินผู้ใช้เข้าสู่ระบบด้วยอีเมลและรหัสผ่านเดิม
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // เปลี่ยนรหัสผ่านใหม่
    await userCredential.user?.updatePassword(newPassword);

    print('รหัสผ่านของคุณถูกเปลี่ยนแล้ว');
  } catch (e) {
    print('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน: $e');
    throw e;
  }
}
