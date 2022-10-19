import 'package:firebase_auth/firebase_auth.dart';

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
  final auth = FirebaseAuth.instance;

  bool get hasCurrentUser => auth.currentUser != null;

  String get requireUid => auth.currentUser!.uid;

  User? get currentUser => auth.currentUser;

  User get requireCurrentUser => auth.currentUser!;

  Future<AuthCode> login(String username, String password) async {
    try {
      final c = await auth.signInWithEmailAndPassword(
          email: _toEmail(username), password: password);
      return AuthCode.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthCode.userNotFound;
      } else if (e.code == 'wrong-password') {
        return AuthCode.wrongPassword;
      }
      return AuthCode.unknownError;
    } catch (e) {
      print(e);
      return AuthCode.error;
    }

  }

  Future<AuthCode> signup(String username, String password) async {
    try {
      final c = await auth.createUserWithEmailAndPassword(
          email: _toEmail(username), password: password);
      return AuthCode.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthCode.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return AuthCode.emailAlreadyInUse;
      }
      return AuthCode.unknownError;
    } catch (e) {
      print(e);
      return AuthCode.error;
    }
  }

  void logout() {
    auth.signOut();
  }

  String _toEmail(String username)=> "$username@service.access";

}
