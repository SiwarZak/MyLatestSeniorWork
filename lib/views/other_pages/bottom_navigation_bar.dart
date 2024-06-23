import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/controllers/attraction_cubit/attraction_cubit.dart';
import 'package:tejwal/controllers/home_cubit/home_cubit.dart';
import 'package:tejwal/controllers/trip_cubit/trip_cubit.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/utils/app_colors.dart';
import 'package:tejwal/views/explore/explore_page.dart';
import 'package:tejwal/views/home/home_page.dart';
import 'package:tejwal/views/profile/profile_page.dart';
import 'package:tejwal/views/other_pages/trips_page.dart';
import 'package:tejwal/views/home/widgets/menu_drawer_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavigationbar extends StatefulWidget {
  const BottomNavigationbar({super.key});

  @override
  State<BottomNavigationbar> createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.uid ?? '';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.lightGray.withOpacity(0.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  width: 250,
                  height: 130,
                  child: Center(child: Image.asset('assets/images/tejwal_logo.png')),
                ),
              ),
              const SizedBox(
                  width: 20,
                  height: 130,
                ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0, //  shadow
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: AppColors.greenShade.withOpacity(0.3),
              height: 2.0,
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: PopScope(
          canPop: false,
          child: PersistentTabView(
            tabs: [
              PersistentTabConfig(
                screen: MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(
                      create: (context) {
                        final cubit = HomeCubit();
                        cubit.getHomeData(userId);
                        return cubit;
                      },
                    ),
                    BlocProvider<AttractionCubit>(
                      create: (context) => AttractionCubit(),
                    ),
                    BlocProvider<TripCubit>(
                      create: (context) => TripCubit(),
                    ),
                  ],
                  child: const HomePage(),
                ),
                item: ItemConfig(
                  icon: const Icon(Icons.home),
                  activeForegroundColor: AppColors.greenShade,
                  inactiveForegroundColor: AppColors.inactiveIconColor,
                  title: "Home",
                ),
              ),
              PersistentTabConfig(
                screen: const ProfilePage(),
                item: ItemConfig(
                  icon: const Icon(Icons.search),
                  activeForegroundColor: AppColors.greenShade,
                  inactiveForegroundColor: AppColors.inactiveIconColor,
                  title: "Search",
                ),
              ),
              PersistentTabConfig(
                screen: const TripsPage(),
                item: ItemConfig(
                  icon: const Icon(Icons.place),
                  activeForegroundColor: AppColors.greenShade,
                  inactiveForegroundColor: AppColors.inactiveIconColor,
                  title: "Place",
                ),
              ),
              PersistentTabConfig(
                screen: const ExplorePage(),
                item: ItemConfig(
                  icon: const Icon(Icons.explore),
                  activeForegroundColor: AppColors.greenShade,
                  inactiveForegroundColor: AppColors.inactiveIconColor,
                  title: "Explore",
                ),
              ),
              PersistentTabConfig(
                screen: const TripsPage(),
                item: ItemConfig(
                  icon: const Icon(Icons.person),
                  activeForegroundColor: AppColors.greenShade,
                  inactiveForegroundColor: AppColors.inactiveIconColor,
                  title: "Profile",
                ),
              ),
            ],
            navBarBuilder: (navBarConfig) => Style9BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: NavBarDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.greenShade.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
