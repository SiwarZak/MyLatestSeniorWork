import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/controllers/attraction_cubit/attraction_cubit.dart';
import 'package:tejwal/controllers/home_cubit/home_cubit.dart';
import 'package:tejwal/controllers/trip_cubit/trip_cubit.dart';
import 'package:tejwal/models/attraction.dart';
import 'package:tejwal/models/trip.dart';
import 'package:tejwal/utils/router/app_routes.dart';
import 'package:tejwal/views/attraction_details/attraction_details_page.dart';
import 'package:tejwal/views/favorites/farvorites_page.dart';
import 'package:tejwal/views/home/home_page.dart';
import 'package:tejwal/views/my_plans/my_plans_page.dart';
import 'package:tejwal/views/my_trips/my_trips_page.dart';
import 'package:tejwal/views/other_pages/not_found_page.dart';
import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';
import 'package:tejwal/views/signin_signup/signup_page.dart';
import 'package:tejwal/views/trip_details/trip_details_page.dart';
import 'package:tejwal/views/user_interests/userInterestsPage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch ((settings.name)) {
      case AppRoutes.bottomNavigationbar:
        return MaterialPageRoute(builder: (_) => const BottomNavigationbar());

      //case AppRoutes.myTrips:
        //return MaterialPageRoute(
           // builder: (_) => const MyTripsPage(), settings: settings);

      case AppRoutes.myPlans:
        return MaterialPageRoute(
            builder: (_) => const MyPlansPage(), settings: settings);

      //case AppRoutes.favorites:
       // return MaterialPageRoute(
         //   builder: (_) => const FavoritesPage(), settings: settings);

      // case AppRoutes.home:
      //   return MaterialPageRoute(
      //       builder: (_) => const HomePage(), settings: settings);

      case AppRoutes.home:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(
                      create: (context) => HomeCubit()..getHomeData(_auth.currentUser!.uid),
                    ),
                    BlocProvider<AttractionCubit>(
                      create: (context) => AttractionCubit()..loadFavorites(),
                    ),
                    BlocProvider<TripCubit>(
                      create: (context) => TripCubit()..loadFavorites(),
                    ),
                  ],
                  child:  BottomNavigationbar(),
                ),
            settings: settings);

      case AppRoutes.attractionDetails:
        final args = settings.arguments as Map;
        final AttractionCubit attractionCubit = args['cubit'];
        final Attraction attraction = args['attraction'];
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: attractionCubit,
                  child: AttractionDetailsPage(
                    attraction: attraction,
                  ),
                ),
            settings: settings);

      case AppRoutes.tripDetails:
        final args = settings.arguments as Map;
        final TripCubit tripCubit = args['cubit'];
        final Trip trip = args['trip'];
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: tripCubit,
                  child: TripDetailsPage(
                    trip: trip,
                  ),
                ),
            settings: settings);

       case AppRoutes.signUp:
        return MaterialPageRoute(
            builder: (_) => SignUpPage(), settings: settings);
        
      case AppRoutes.userInterests:
        return MaterialPageRoute(
            builder: (_) => UserInterestsPage(), settings: settings);

      default:
        return MaterialPageRoute(
            builder: (_) => const NotFoundPage(), settings: settings);
    }
  }
}
