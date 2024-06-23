import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'attraction_state.dart';

class AttractionCubit extends Cubit<AttractionState> {
  AttractionCubit() : super(AttractionInitial(const {})) { //this block is to load favorites from firebase as the user logs in, so that favorites are not lost after logging out and in again
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        loadFavorites();
      }
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadFavorites() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot snapshot = await _firestore.collection('favorites')
          .where('user_id', isEqualTo: user.uid)
          .get();

      Map<String, bool> favorites = {};
      for (var doc in snapshot.docs) {
        favorites[doc['item_id']] = true;
      }

      emit(AttractionFavoriteStatusChanged(favorites));
    } catch (e) {
      emit(AttractionFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  Future<void> initializeFavoriteStatus(String attractionId) async {
    try {
      bool isFavorite = await _isFavorite(attractionId);
      _updateFavoriteStatus(attractionId, isFavorite);
    } catch (e) {
      emit(AttractionFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  Future<void> toggleFavoriteStatus(String attractionId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      DocumentReference favoriteRef = _firestore.collection('favorites').doc('${user.uid}_$attractionId');

      final doc = await favoriteRef.get();

      bool isFavorite;
      if (doc.exists) {
        await favoriteRef.delete();
        isFavorite = false;
      } else {
        Map<String, dynamic> favoriteData = {
          'user_id': user.uid,
          'item_id': attractionId,
          'timestamp': FieldValue.serverTimestamp(),
        };
        await favoriteRef.set(favoriteData);
        isFavorite = true;
      }
      _updateFavoriteStatus(attractionId, isFavorite);
    } catch (e) {
      emit(AttractionFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  void _updateFavoriteStatus(String attractionId, bool isFavorite) {
    if (state is AttractionFavoriteStatusChanged) {
      final currentState = state as AttractionFavoriteStatusChanged;
      final updatedFavorites = Map<String, bool>.from(currentState.favorites)
        ..[attractionId] = isFavorite;
      emit(AttractionFavoriteStatusChanged(updatedFavorites));
    } else if (state is AttractionInitial) {
      final currentState = state as AttractionInitial;
      final updatedFavorites = Map<String, bool>.from(currentState.favorites)
        ..[attractionId] = isFavorite;
      emit(AttractionFavoriteStatusChanged(updatedFavorites));
    } else {
      emit(AttractionFavoriteStatusChanged({attractionId: isFavorite}));
    }
  }

  Future<bool> _isFavorite(String attractionId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    DocumentReference favoriteRef = _firestore.collection('favorites').doc('${user.uid}_$attractionId');
    final doc = await favoriteRef.get();
    return doc.exists;
  }
}
