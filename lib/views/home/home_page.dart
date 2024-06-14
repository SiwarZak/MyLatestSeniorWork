import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/controllers/attraction_cubit/attraction_cubit.dart';
import 'package:tejwal/controllers/home_cubit/home_cubit.dart';
import 'package:tejwal/controllers/trip_cubit/trip_cubit.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/views/home/widgets/section_with_title_and_containers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final attractionCubit = BlocProvider.of<AttractionCubit>(context);
    //final tripCubit = BlocProvider.of<TripCubit>(context); //to be passed to the trip details page

    // Check if the user is logged in
    if (authProvider.currentUser != null) {
      // Pass the user ID to getHomeData
      homeCubit.getHomeData(authProvider.currentUser!.uid);
    }

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeError) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is HomeLoaded) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionWithTitleAndContainers(
                    title: 'أماكن مقترحة',
                    contentList: state.recommendedAttractions,
                    cubit: attractionCubit,
                    pageName: 'attractionDetailsPage',
                  ),
                  const SizedBox(height: 20),
                  SectionWithTitleAndContainers(
                    title: 'أماكن في مدينتك',
                    contentList: state.cityBasedAttractions,
                    cubit: attractionCubit,
                    pageName: 'attractionDetailsPage',
                    isCityBased: true, // Indicate that this section is city-based
                  ),
                  const SizedBox(height: 20),
                  SectionWithTitleAndContainers(
                    title: 'أماكن تناسب اهتماماتك',
                    contentList: state.interestBasedAttractions,
                    cubit: attractionCubit,
                    pageName: 'attractionDetailsPage',
                  ),
                  const SizedBox(height: 20),
                  SectionWithTitleAndContainers(
                    title: 'أماكن تناسب خصائصك',
                    contentList: state.propertyBasedAttractions,
                    cubit: attractionCubit,
                    pageName: 'attractionDetailsPage',
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}



// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late HomeCubit homeCubit;
//   late String userId;

//   @override
//   void initState() {
//     super.initState();
//     homeCubit = BlocProvider.of<HomeCubit>(context);
//     userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.uid ?? '';

//     if (userId.isNotEmpty) {
//       homeCubit.getHomeData(userId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final attractionCubit = BlocProvider.of<AttractionCubit>(context);

//     return BlocBuilder<HomeCubit, HomeState>(
//       bloc: homeCubit,
//       builder: (context, state) {
//         if (state is HomeLoading) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         } else if (state is HomeError) {
//           return Center(
//             child: Text(state.message),
//           );
//         } else if (state is HomeLoaded) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SectionWithTitleAndContainers(
//                     title: 'أماكن مقترحة',
//                     contentList: state.recommendedAttractions,
//                     cubit: attractionCubit,
//                     pageName: 'attractionDetailsPage',
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
