import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getUserLocation() async {
    try {
      emit(LocationLoading());
      Location location = Location();
      LocationData locationData = await location.getLocation();
      emit(LocationLoaded(locationData));
    } catch (e) {
      emit(LocationError('Failed to get location'));
    }
  }
}