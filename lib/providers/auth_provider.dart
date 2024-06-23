import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejwal/services/recombee_service.dart';
import 'package:tejwal/models/attraction.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? _currentUser;
  final RecombeeService _recombeeService = RecombeeService();
  List<Attraction> _recommendedAttractions = [];
  List<Attraction> _cityBasedAttractions = [];
  List<Attraction> _interestBasedAttractions = [];
  List<Attraction> _propertyBasedAttractions = [];

  User? get currentUser => _currentUser;
  List<Attraction> get recommendedAttractions => _recommendedAttractions;
  List<Attraction> get cityBasedAttractions => _cityBasedAttractions;
  List<Attraction> get interestBasedAttractions => _interestBasedAttractions;
  List<Attraction> get propertyBasedAttractions => _propertyBasedAttractions;

  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Added GoogleSignIn instance

  AuthProvider() {
    _loadCurrentUser();
  }
  
  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    if (userId != null && FirebaseAuth.instance.currentUser != null) {
      _currentUser = FirebaseAuth.instance.currentUser;
      await fetchRecommendations(userId);
      await fetchCityBasedRecommendations(userId);
      await fetchInterestBasedRecommendations(userId);
      await fetchPropertyBasedRecommendations(userId);
      notifyListeners();
    }
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = userCredential.user;

      if (_currentUser != null) {
        // Save user data to Firebase
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(_currentUser!.uid)
            .set({
          "fullName": fullName.trim(),
          "email": email.trim(),
          "userId": _currentUser!.uid,
          "password":password.trim()
        });
        await _saveUserId(_currentUser!.uid);

        // Save user data to Recombee
        await _recombeeService.addUserData(_currentUser!.uid, email, '', []);

        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      onError(_handleFirebaseAuthError(e));
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = userCredential.user;

      if (_currentUser != null) {
        await _saveUserId(_currentUser!.uid);
        print('User ID: ${_currentUser!.uid}');
        await fetchRecommendations(_currentUser!.uid);
        await fetchCityBasedRecommendations(_currentUser!.uid);
        await fetchInterestBasedRecommendations(_currentUser!.uid);
        await fetchPropertyBasedRecommendations(_currentUser!.uid);
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      onError(_handleFirebaseAuthError(e));
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }  

  // Added Google Sign-In logic
  Future<void> signInWithGoogle({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If the user cancels the sign-in
        onError('Google Sign-In aborted');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      _currentUser = userCredential.user;

      if (_currentUser != null) {
        await _saveUserId(_currentUser!.uid);

        // Check if user data already exists in Firestore
        var userDoc = await FirebaseFirestore.instance.collection('userData').doc(_currentUser!.uid).get();
        if (!userDoc.exists) {
          // Save new user data to Firebase
          await FirebaseFirestore.instance
              .collection('userData')
              .doc(_currentUser!.uid)
              .set({
            "fullName": _currentUser!.displayName ?? '',
            "email": _currentUser!.email ?? '',
            "userId": _currentUser!.uid,
          });

          // Save user data to Recombee
          await _recombeeService.addUserData(_currentUser!.uid, _currentUser!.email ?? '', '', []);
        }

        await fetchRecommendations(_currentUser!.uid);
        await fetchCityBasedRecommendations(_currentUser!.uid);
        await fetchInterestBasedRecommendations(_currentUser!.uid);
        await fetchPropertyBasedRecommendations(_currentUser!.uid);
        onSuccess();
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendations(String userId) async {
    try {
      List<dynamic> recommendedAttractionIds = await _recombeeService.getUserRecommendations(userId, 10);
      List<Attraction> recommendedAttractions = [];

      for (var recommendation in recommendedAttractionIds) {
        String attractionId = recommendation['id'].toString();
        var doc = await FirebaseFirestore.instance.collection('attractions').doc(attractionId).get();
        if (doc.exists) {
          recommendedAttractions.add(Attraction.fromFirestore(doc));
        }
      }
      _recommendedAttractions = recommendedAttractions;
      print('Recommended Attractions: $_recommendedAttractions');
    } catch (e) {
      print('Failed to fetch recommendations: $e');
    }
  }
  
  //Password reset logic
  Future<void> sendPasswordResetEmail({
    required String email,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(_handleFirebaseAuthError(e));
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCityBasedRecommendations(String userId) async {
    try {
      List<dynamic> cityBasedRecommendations = await _recombeeService.getCityBasedRecommendations(userId, 10);
      List<Attraction> cityBasedAttractions = [];

      for (var recommendation in cityBasedRecommendations) {
        String city = recommendation['id'].toString();
        var querySnapshot = await FirebaseFirestore.instance.collection('attractions').where('city', isEqualTo: city).get();
        for (var doc in querySnapshot.docs) {
          cityBasedAttractions.add(Attraction.fromFirestore(doc));
        }
      }
      _cityBasedAttractions = cityBasedAttractions;
      print('City-Based Attractions: $_cityBasedAttractions');
    } catch (e) {
      print('Failed to fetch city-based recommendations: $e');
    }
  }

  Future<void> fetchInterestBasedRecommendations(String userId) async {
    try {
      List<dynamic> interestBasedRecommendations = await _recombeeService.getInterestBasedRecommendations(userId, 10);
      List<Attraction> interestBasedAttractions = [];

      for (var recommendation in interestBasedRecommendations) {
        String interest = recommendation['id'].toString();
        var querySnapshot = await FirebaseFirestore.instance.collection('attractions').where('subcategory', arrayContains: interest).get();
        for (var doc in querySnapshot.docs) {
          interestBasedAttractions.add(Attraction.fromFirestore(doc));
        }
      }
      _interestBasedAttractions = interestBasedAttractions;
      print('Interest-Based Attractions: $_interestBasedAttractions');
    } catch (e) {
      print('Failed to fetch interest-based recommendations: $e');
    }
  }

  Future<void> fetchPropertyBasedRecommendations(String userId) async {
    try {
      List<dynamic> propertyBasedRecommendations = await _recombeeService.getPropertyBasedRecommendations(userId, 10);
      List<Attraction> propertyBasedAttractions = [];

      for (var recommendation in propertyBasedRecommendations) {
        String property = recommendation['id'].toString();
        var querySnapshot = await FirebaseFirestore.instance.collection('attractions').where('properties', arrayContains: property).get();
        for (var doc in querySnapshot.docs) {
          propertyBasedAttractions.add(Attraction.fromFirestore(doc));
        }
      }
      _propertyBasedAttractions = propertyBasedAttractions;
      print('Property-Based Attractions: $_propertyBasedAttractions');
    } catch (e) {
      print('Failed to fetch property-based recommendations: $e');
    }
  }

  Future<void> updateUserData({
    required List<String> interests,
    required String city,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (_currentUser == null) {
      onError("User not logged in");
      return;
    }

    try {
      final userId = _currentUser!.uid;
      final email = _currentUser!.email ?? '';

      // Update user data in Firebase
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .update({
        "interests": interests,
        "city": city,
      });

      // Update user data in Recombee
      await _recombeeService.addUserData(userId, email, city, interests);

      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _currentUser = null;
    notifyListeners();
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return "كلمة المرور ضعيفة جدًا";
      case 'email-already-in-use':
        return "الحساب موجود بالفعل لهذا البريد الإلكتروني";
      default:
        return e.message ?? "An unexpected error occurred";
    }
  }
}

