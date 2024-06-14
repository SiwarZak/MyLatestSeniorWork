part of 'attraction_cubit.dart';

@immutable
sealed class AttractionState {}

final class AttractionInitial extends AttractionState {
  final Map<String, bool> favorites;
  AttractionInitial(this.favorites);
}

final class AttractionLoading extends AttractionState {} //not used

final class AttractionLoaded extends AttractionState {} //not used

//must be emitted when the attraction is successfully added to favorites
// class AttractionAddedToFavoritesSuccess extends AttractionState {
//   final String attractionId;
//   AttractionAddedToFavoritesSuccess(this.attractionId);
// }

class AttractionAddedToFavoritesFailure extends AttractionState {
  final String errorMessage;
  AttractionAddedToFavoritesFailure(this.errorMessage);
}

class AttractionFavoriteStatusChanged extends AttractionState {
  final Map<String, bool> favorites;
  final String? error;

  AttractionFavoriteStatusChanged(this.favorites, {this.error});
}
