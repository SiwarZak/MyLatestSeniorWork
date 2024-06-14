part of 'trip_cubit.dart';

@immutable
abstract class TripState {}

class TripInitial extends TripState {
  final Map<String, bool> favorites;
  TripInitial(this.favorites);
}

final class TripLoading extends TripState {} //not used

final class TripLoaded extends TripState {} //not used

//must be emitted when the trip is successfully added to favorites
class TripAddedToFavoritesSuccess extends TripState {
  final String tripId;
  TripAddedToFavoritesSuccess(this.tripId);
}

class TripAddedToFavoritesFailure extends TripState {
  final String errorMessage;
  TripAddedToFavoritesFailure(this.errorMessage);
}

class TripFavoriteStatusChanged extends TripState {
  final Map<String, bool> favorites;
  final String? error;

  TripFavoriteStatusChanged(this.favorites, {this.error});
}

//must be eimted when the registeration is being processed
 final class TripRegisterLoading extends TripState {} 

 //must be eimted when the registeration is successful
 final class TripRegisterSuccessful extends TripState {} 