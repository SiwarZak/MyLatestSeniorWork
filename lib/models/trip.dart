class Trip {
  final String id;
  final String name;
  final String description;
  final List<String> categories; //*
  final String departurePoint; 
  final String departureTime; 
  final Map<String,String> tripPath; //* includes the places that the trip includes (each map item => 'time':'details')
  final String day; 
  final String date; 
  final int fee;
  final List<String> images;
  final List<String> importantNotes; //*
  final List<String> properties;

  Trip({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.departurePoint,
    required this.departureTime,
    required this.tripPath,
    required this.fee,
    required this.day,
    required this.date,
    required this.images,
    required this.importantNotes,
    required this.properties,
  });
}
