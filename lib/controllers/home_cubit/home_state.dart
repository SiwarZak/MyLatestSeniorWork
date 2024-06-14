part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Attraction> recommendedAttractions;
  final List<Attraction> cityBasedAttractions;
  final List<Attraction> interestBasedAttractions;
  final List<Attraction> propertyBasedAttractions;

  HomeLoaded({
    required this.recommendedAttractions,
    required this.cityBasedAttractions,
    required this.interestBasedAttractions,
    required this.propertyBasedAttractions,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
