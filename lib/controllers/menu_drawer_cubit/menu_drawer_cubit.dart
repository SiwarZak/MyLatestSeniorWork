import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'menu_drawer_state.dart';

class MenuDrawerCubit extends Cubit<MenuDrawerState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  MenuDrawerCubit(this._auth, this._firestore) : super(MenuDrawerInitial());

  void fetchUserDetails() async {
    emit(MenuDrawerLoading());
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final userDoc = await _firestore.collection('userData').doc(userId).get();
        final fullName = userDoc['fullName'] as String;
        final email = _auth.currentUser!.email ?? '';
        emit(MenuDrawerLoaded(fullName: fullName, email: email));
      } else {
        emit(MenuDrawerError("User not logged in"));
      }
    } catch (e) {
      emit(MenuDrawerError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(MenuDrawerLoading());
    try {
      await _auth.signOut();
      emit(MenuDrawerInitial());
    } catch (e) {
      emit(MenuDrawerError(e.toString()));
    }
  }
}
