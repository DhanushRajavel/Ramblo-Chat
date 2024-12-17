import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp(
      {required String name,
      required String mobile,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "name": name.trim(),
        "mobile": mobile.trim(),
        "email": email.trim(),
        "password": password.trim()
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> storeChatDataToDb({
    required String email,
    required String text,
    required String creator,
  }) async {
    try {
      await _firestore.collection('messages').add({
        "email": email.trim(),
        "text": text.trim(),
        "creator": creator.trim()
      });
    } catch (e) {
      return e.toString();
    }
  }
}
