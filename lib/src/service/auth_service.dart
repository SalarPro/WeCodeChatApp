import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//methode to register the user using email and password

  Future<UserCredential?> registerWihtEmailAndPassword(
      String emila, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: emila, password: password);
    //TODO: handl Errors
    return userCredential;
  }

//methode to login the user using email and password

  Future<UserCredential?> loginWihtEmailAndPassword(
      String emila, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: emila, password: password);
    //TODO: handl Errors
    return userCredential;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
