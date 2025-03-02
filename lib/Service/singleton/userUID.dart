import 'package:cloud_firestore/cloud_firestore.dart';

class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();
  String? _uid;

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();

  String? get uid => _uid;

  void setUID(String uid) async {
    _uid = uid;
    print(_uid);
  }
}
