import 'package:clinic/models/user.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from Firebase User
  MyUser _userFromFirbaseUser(User user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirbaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPasword(
      String email, password, fName, lName, phoneNumber, gender, role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // create new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
          fName, lName, phoneNumber, gender, role, password, email);

      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
