import 'package:flutter/material.dart';
import 'package:tejwal/utils/app_colors.dart';
import 'package:tejwal/utils/router/app_routes.dart';

class ProfileListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final BuildContext context; //to be used for navigation
  final String pageName; //to determine what page the listTile navigates to

  const ProfileListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.context,
      required this.pageName});

  @override
  Widget build(BuildContext context) {
    return listItem();
  }

  Widget listItem() {
    return ListTile(
      onTap: () {
        if (pageName == AppRoutes.myTrips) {
          Navigator.of(context).pushNamed(AppRoutes.myTrips);
        } else if (pageName == AppRoutes.myPlans) {
          Navigator.of(context).pushNamed(AppRoutes.myPlans);
        }else if(pageName == AppRoutes.favorites){
          Navigator.of(context).pushNamed(AppRoutes.favorites);
        }
      },
      leading: Icon(
        leadingIcon,
        size: 30,
        color: AppColors.greenShade,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }
}
