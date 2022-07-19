import 'package:firebase_auth/firebase_auth.dart';

import '../models/response_status.dart';

class AuthServices{
  late final FirebaseAuth _auth;

  AuthServices(){
    _auth = FirebaseAuth.instance;
  }

  Future<Status> signIn({required String email, required String password}) async {

    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => Success(response: "User signed in successfully"));
    } on FirebaseAuthException catch (e){
      return Failure(code: e.code, response: _handleSignInError(e));
    }
  }

  Future<Status> signOut() async {
    try {
      return await _auth.signOut().then((value) => Success(response: "User signed out successfully"));
    } on FirebaseAuthException catch (e){
      return Failure(code: e.code, response: _handleSignInError(e));
    }
  }

  Future<Status> forgotPassword({required String email}) async {

    try {
      return await _auth.sendPasswordResetEmail(email: email).then((value) => Success(response: "Password reset email sent successfully"));
    } on FirebaseAuthException catch (e){
      return Failure(code: e.code, response: _handleSignInError(e));
    }
  }

  Stream<User?> authStream() {
    return _auth.authStateChanges();
  }

  String _handleSignInError(FirebaseAuthException e) {
    String error;
    switch (e.code) {
      case 'email-already-in-use':
        error = 'This email is already in use';
        break;
      case 'user-not-found':
        error = 'User not registered';
        break;
      case 'invalid-email':
        error = 'The email you entered is invalid';
        break;
      case 'operation-not-allowed':
        error = 'This operation is not allowed';
        break;
      case 'weak-password':
        error = 'The password you entered is too weak';
        break;
      default:
        error = e.message!;
        break;
    }
    return error;
  }
}