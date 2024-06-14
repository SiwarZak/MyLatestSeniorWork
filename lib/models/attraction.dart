import 'package:cloud_firestore/cloud_firestore.dart';

class Attraction {
  final String id;
  final String category;
  final String name;
  final String description;
  final String city;
  final String? phone;
  final double? rating;
  final List<String> properties;
  final String? openAt;
  final List<String> images;

  Attraction({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.city,
    this.phone,
    this.rating,
    required this.properties,
    this.openAt,
    required this.images,
  });

  factory Attraction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Attraction(
      id: doc.id,
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'],
      rating: data['rating']?.toDouble(),
      properties: List<String>.from(data['properties'] ?? []),
      openAt: data['openAt'],
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
