/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Map<String, dynamic>> categories = [
    {'text': 'Open now', 'icon': Icons.access_time},
    {'text': 'Top rated', 'icon': Icons.star},
    {'text': 'More filters', 'icon': Icons.filter_list},
    {'text': 'More filters', 'icon': Icons.filter_list},
    // Add more categories as needed
  ];

  int _selectedCategoryIndex = 0;
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(31.9522, 35.2332), // Default to Palestine coordinates
    zoom: 6, // Adjust the zoom level as needed
  );

  Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                    // Implement category selection action, such as filtering markers
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == index ? Colors.green[600] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _selectedCategoryIndex == index ? Colors.green : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(categories[index]['icon'], color: _selectedCategoryIndex == index ? Colors.white : Colors.grey),
                      SizedBox(width: 5),
                      Text(categories[index]['text'],
                          style: TextStyle(color: _selectedCategoryIndex == index ? Colors.white : Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<GoogleMapController>(
            future: _controllerCompleter.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerCompleter.complete(controller);
                  },
                  // Add markers, polylines, and other features here
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
*/