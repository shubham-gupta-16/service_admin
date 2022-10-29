import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthCode {
  weakPassword,
  emailAlreadyInUse,
  userNotFound,
  wrongPassword,
  error,
  success,
  unknownError
}

class Auth {

  final SharedPreferences? _pref;

  Auth(this._pref);
  // Future<void> _initPref() async {
  //   _pref = await SharedPreferences.getInstance();
  // }
  //
  // Auth() {
  //   _initPref();
  // }



  Future<void> setUserName(String username) async {
    await _pref?.setString('username', username);
  }

  String get requireUsername => getUserName()!;

  String? getUserName() {
    return _pref?.getString("username");
  }

  bool get hasCurrentUser => getUserName() != null;

  Future<AuthCode> login(String username, String password) async {
    try {
      final snapshot = await DbRef.getRootRef().child(DbRef.admin).child(username).get();
      if(!snapshot.exists) return AuthCode.userNotFound;
      final hashPass = snapshot.child("hash").value.toString();
      if (password == hashPass) {
        setUserName(username);
        return AuthCode.success;
      }
      return AuthCode.wrongPassword;
    } on FirebaseAuthException catch (e) {
      return AuthCode.error;
    }
  }

  Future<void> logout() async {
    await _pref?.remove('username');
  }
}
