import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/models/attraction.dart';
import 'package:tejwal/services/recombee_service.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RecombeeService _recombeeService = RecombeeService();

  Future<void> getHomeData(String userId) async {
    emit(HomeLoading());
    try {
      Set<String> seenAttractions = {};

      // Fetch recommended attraction IDs from Recombee
      List<dynamic> recommendedAttractionIds = await _recombeeService.getUserRecommendations(userId, 10);
      List<Attraction> recommendedAttractions = await _fetchAttractionsById(recommendedAttractionIds, seenAttractions);

      // Fetch city-based recommendations
      List<dynamic> cityBasedRecommendationIds = await _recombeeService.getCityBasedRecommendations(userId, 10);
      List<Attraction> cityBasedAttractions = await _fetchAttractionsByCity(cityBasedRecommendationIds, seenAttractions);

      // Fetch interest-based recommendations
      List<dynamic> interestBasedRecommendationIds = await _recombeeService.getInterestBasedRecommendations(userId, 10);
      List<Attraction> interestBasedAttractions = await _fetchAttractionsBySubcategory(interestBasedRecommendationIds, seenAttractions);

      // Fetch property-based recommendations
      List<dynamic> propertyBasedRecommendationIds = await _recombeeService.getPropertyBasedRecommendations(userId, 10);
      List<Attraction> propertyBasedAttractions = await _fetchAttractionsByProperty(propertyBasedRecommendationIds, seenAttractions);

      emit(HomeLoaded(
        recommendedAttractions: recommendedAttractions,
        cityBasedAttractions: cityBasedAttractions,
        interestBasedAttractions: interestBasedAttractions,
        propertyBasedAttractions: propertyBasedAttractions,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<List<Attraction>> _fetchAttractionsById(List<dynamic> recommendationIds, Set<String> seenAttractions) async {
    List<Attraction> attractions = [];

    for (var recommendation in recommendationIds) {
      String attractionId = recommendation['id'].toString();
      if (seenAttractions.contains(attractionId)) continue;

      var doc = await _firestore.collection('attractions').doc(attractionId).get();
      if (doc.exists) {
        seenAttractions.add(attractionId);
        attractions.add(Attraction.fromFirestore(doc));
      }
    }

    return attractions;
  }

  Future<List<Attraction>> _fetchAttractionsByCity(List<dynamic> recommendationIds, Set<String> seenAttractions) async {
    List<Attraction> attractions = [];

    for (var recommendation in recommendationIds) {
      String recommendedCity = recommendation['id'].toString();
      var querySnapshot = await _firestore.collection('attractions')
          .where('city', isEqualTo: recommendedCity)
          .limit(2)
          .get();

      for (var doc in querySnapshot.docs) {
        String attractionId = doc.id;
        if (seenAttractions.contains(attractionId)) continue;

        if (doc.exists) {
          seenAttractions.add(attractionId);
          attractions.add(Attraction.fromFirestore(doc));
        }
      }
    }

    return attractions;
  }

  Future<List<Attraction>> _fetchAttractionsBySubcategory(List<dynamic> recommendationIds, Set<String> seenAttractions) async {
    List<Attraction> attractions = [];

    for (var recommendation in recommendationIds) {
      String recommendedSubcategory = recommendation['id'].toString();
      var querySnapshot = await _firestore.collection('attractions')
          .where('subcategory', arrayContains: recommendedSubcategory)
          .limit(2)
          .get();

      for (var doc in querySnapshot.docs) {
        String attractionId = doc.id;
        if (seenAttractions.contains(attractionId)) continue;

        if (doc.exists) {
          seenAttractions.add(attractionId);
          attractions.add(Attraction.fromFirestore(doc));
        }
      }
    }

    return attractions;
  }

  Future<List<Attraction>> _fetchAttractionsByProperty(List<dynamic> recommendationIds, Set<String> seenAttractions) async {
    List<Attraction> attractions = [];

    for (var recommendation in recommendationIds) {
      String recommendedProperty = recommendation['id'].toString();
      var querySnapshot = await _firestore.collection('attractions')
          .where('properties', arrayContains: recommendedProperty)
          .limit(2)
          .get();

      for (var doc in querySnapshot.docs) {
        String attractionId = doc.id;
        if (seenAttractions.contains(attractionId)) continue;

        if (doc.exists) {
          seenAttractions.add(attractionId);
          attractions.add(Attraction.fromFirestore(doc));
        }
      }
    }

    return attractions;
  }
}
