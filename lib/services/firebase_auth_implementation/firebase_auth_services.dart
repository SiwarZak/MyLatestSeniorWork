import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await _saveUserData(userCredential.user);
      return userCredential.user;
    } catch (e) {
      print('Error in signInWithEmailAndPassword: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _saveUserData(userCredential.user);
      return userCredential.user;
    } catch (e) {
      print('Error in signUpWithEmailAndPassword: $e');
      return null;
    }
  }

  Future<void> _saveUserData(User? user) async {
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await user.getIdToken();
      await prefs.setString('userToken', token ?? '');
      await prefs.setString('userEmail', user.email ?? '');
      await prefs.setString('userId', user.uid);

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'lastLogin': DateTime.now(),
        // Add other user data as needed
      }, SetOptions(merge: true));
    }
  }

  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    String? email = prefs.getString('userEmail');
    String? userId = prefs.getString('userId');

    return {
      'token': token,
      'email': email,
      'userId': userId,
    };
  }

  Future<void> logoutUser() async {
    await _firebaseAuth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('userEmail');
    await prefs.remove('userId');
  }
}
