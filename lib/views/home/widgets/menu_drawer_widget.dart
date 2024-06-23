import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/controllers/menu_drawer_cubit/menu_drawer_cubit.dart';
import 'package:tejwal/utils/router/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MenuDrawerCubit(FirebaseAuth.instance,FirebaseFirestore.instance,)..fetchUserDetails(),
        child: BlocConsumer<MenuDrawerCubit, MenuDrawerState>(
        listener: (context, state) {
          if (state is MenuDrawerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MenuDrawerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuDrawerLoaded) {
            return Stack(
              children: [
                Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text(state.fullName),
                        accountEmail: Text(state.email),
                        currentAccountPicture: const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/pal1.jpg'),
                        ),
                      ),
                      _createDrawerItem(
                        icon: Icons.map,
                        text: 'الخريطة',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
                      ),
                      _createDrawerItem(
                        icon: Icons.card_travel,
                        text: 'رحلاتي',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.event_note,
                        text: 'خططي',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.shopping_cart,
                        text: 'السوق',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.bookmark,
                        text: 'المحفوظات',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.explore,
                        text: 'ابن بطوطة',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.help,
                        text: 'الدليل',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.settings,
                        text: 'الإعدادات',
                        onTap: () => Navigator.pop(context),
                      ),
                      _createDrawerItem(
                        icon: Icons.logout,
                        text: 'تسجيل الخروج',
                        onTap: () async {
                          context.read<MenuDrawerCubit>().signOut();
                          Navigator.of(context).pushNamed(AppRoutes.logIn);
                        },
                      ),
                    ],
                  ),
                ),
                if (state is MenuDrawerLoading)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  Widget _createDrawerItem({IconData? icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tejwal/providers/auth_provider.dart';
// import 'package:tejwal/views/signin_signup/login_page.dart';
// import 'package:tejwal/utils/router/app_routes.dart';

// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});

//   @override
//   _CustomDrawerState createState() => _CustomDrawerState();
// }

// class _CustomDrawerState extends State<CustomDrawer> {
//   bool _isLoading = false;
//   String? _fullName;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserDetails();
//   }

//   Future<void> _fetchUserDetails() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userId = authProvider.currentUser?.uid;

//     if (userId != null) {
//       final userDoc = await FirebaseFirestore.instance.collection('userData').doc(userId).get();
//       setState(() {
//         _fullName = userDoc['fullName'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     return Stack(
//       children: [
//         Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               UserAccountsDrawerHeader(
//                 accountName: Text(_fullName ?? 'جار التحميل...'),
//                 accountEmail: Text(authProvider.currentUser?.email ?? ''),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/tree.jpg'), 
//                 ),
//               ),
//               _createDrawerItem(
//                 icon: Icons.map,
//                 text: 'الخريطة',
//                 onTap: () => Navigator.pop(context), 
//               ),
//               _createDrawerItem(
//                 icon: Icons.card_travel,
//                 text: 'رحلاتي',
//                 onTap: () => Navigator.pop(context), 
//               ),
//               _createDrawerItem(
//                 icon: Icons.event_note,
//                 text: 'خططي',
//                 onTap: () => Navigator.pop(context), 
//               ),
//               _createDrawerItem(
//                 icon: Icons.shopping_cart,
//                 text: 'السوق',
//                 onTap: () => Navigator.pop(context), 
//               ),
//               _createDrawerItem(
//                 icon: Icons.bookmark,
//                 text: 'المحفوظات',
//                 onTap: () => Navigator.pop(context), // Replace with your navigation code
//               ),
//               _createDrawerItem(
//                 icon: Icons.explore,
//                 text: 'ابن بطوطة',
//                 onTap: () => Navigator.pop(context), // Replace with your navigation code
//               ),
//               _createDrawerItem(
//                 icon: Icons.help,
//                 text: 'الدليل',
//                 onTap: () => Navigator.pop(context), // Replace with your navigation code
//               ),
//               _createDrawerItem(
//                 icon: Icons.settings,
//                 text: 'الإعدادات',
//                 onTap: () => Navigator.pop(context), // Replace with your navigation code
//               ),
//               _createDrawerItem(
//                 icon: Icons.logout,
//                 text: 'تسجيل الخروج',
//                 onTap: () async {
//                   setState(() {
//                     _isLoading = true;
//                   });
//                   final userId = authProvider.currentUser?.uid;
//                   print('User $userId signed out');
//                   await authProvider.signOut();
//                   setState(() {
//                     _isLoading = false;
//                   });
//                   Navigator.pop(context); // Close the drawer
//                   //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()),);// Navigate to login page
//                   Navigator.of(context).pushNamed(AppRoutes.logIn);
//                 },
//               ),
//             ],
//           ),
//         ),
//         if (_isLoading)
//           Container(
//             color: Colors.black45,
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _createDrawerItem({IconData? icon, required String text, VoidCallback? onTap}) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(text),
//       onTap: onTap,
//     );
//   }
// }
