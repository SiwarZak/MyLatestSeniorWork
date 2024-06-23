import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripInitial(const {})){ //this block is to load favorites from firebase as the user logs in, so that favorites are not lost after logging out and in again
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        loadFavorites();
      }
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Load all favorite statuses for the current user
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

      emit(TripFavoriteStatusChanged(favorites));
    } catch (e) {
      emit(TripFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  Future<void> initializeFavoriteStatus(String tripId) async {
    try {
      bool isFavorite = await _isFavorite(tripId);
      _updateFavoriteStatus(tripId, isFavorite);
    } catch (e) {
      emit(TripFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  Future<void> toggleFavoriteStatus(String tripId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      DocumentReference favoriteRef = _firestore.collection('favorites').doc('${user.uid}_$tripId');

      final doc = await favoriteRef.get();

      bool isFavorite;
      if (doc.exists) {
        await favoriteRef.delete();
        isFavorite = false;
      } else {
        Map<String, dynamic> favoriteData = {
          'user_id': user.uid,
          'item_id': tripId,
          'timestamp': FieldValue.serverTimestamp(),
        };
        await favoriteRef.set(favoriteData);
        isFavorite = true;
      }
      _updateFavoriteStatus(tripId, isFavorite);
    } catch (e) {
      emit(TripFavoriteStatusChanged(const {}, error: e.toString()));
    }
  }

  void _updateFavoriteStatus(String tripId, bool isFavorite) {
    if (state is TripFavoriteStatusChanged) {
      final currentState = state as TripFavoriteStatusChanged;
      final updatedFavorites = Map<String, bool>.from(currentState.favorites)
        ..[tripId] = isFavorite;
      emit(TripFavoriteStatusChanged(updatedFavorites));
    } else if (state is TripInitial) {
      final currentState = state as TripInitial;
      final updatedFavorites = Map<String, bool>.from(currentState.favorites)
        ..[tripId] = isFavorite;
      emit(TripFavoriteStatusChanged(updatedFavorites));
    } else {
      emit(TripFavoriteStatusChanged({tripId: isFavorite}));
    }
  }

  Future<bool> _isFavorite(String tripId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    DocumentReference favoriteRef = _firestore.collection('favorites').doc('${user.uid}_$tripId');
    final doc = await favoriteRef.get();
    return doc.exists;
  }

  void registerForTrip(){
     //TODO
   }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';

// part 'trip_state.dart';

// class TripCubit extends Cubit<TripState> {
//   TripCubit() : super(TripInitial());

//   void addTripToFavorites(){
//     //TODO
//   }

   
// }
