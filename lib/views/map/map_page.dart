import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tejwal/controllers/location_cubit/location_cubit.dart';


class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationLoaded) {
            LatLng currentLatLng = LatLng(
              state.locationData.latitude!,
              state.locationData.longitude!,
            );

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLatLng,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {},
            );
          } else if (state is LocationError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Press the button to get location'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<LocationCubit>().getUserLocation(),
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
