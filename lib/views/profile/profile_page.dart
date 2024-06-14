import 'package:flutter/material.dart';
import 'package:tejwal/utils/router/app_routes.dart';
import 'package:tejwal/views/profile/widgets/profile_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              CircleAvatar(
                  radius:
                      size.width > 800 ? size.height * 0.2 : size.height * 0.12,
                  backgroundImage: const AssetImage('assets/images/tree.jpg')),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                'Ali Ahmad',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24.0,
              ),
            
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              ProfileListTile(
                leadingIcon: Icons.directions_walk,
                title: 'رحلاتي',
                context: context,
                pageName: AppRoutes.myTrips,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              ProfileListTile(
                leadingIcon: Icons.event_note,
                title: 'خططي',
                context: context,
                pageName: AppRoutes.myPlans,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              ProfileListTile(
                leadingIcon: Icons.favorite_border_outlined,
                title: 'المفضلة',
                context: context,
                pageName: AppRoutes.favorites,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
