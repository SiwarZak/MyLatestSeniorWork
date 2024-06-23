part of "location_cubit.dart";

abstract class LocationState{}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationData locationData;

  LocationLoaded(this.locationData);

  @override
  List<Object?> get props => [locationData];
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
