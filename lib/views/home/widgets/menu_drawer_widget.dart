import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/views/signin_signup/login_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoading = false;
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.uid;

    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('userData').doc(userId).get();
      setState(() {
        _fullName = userDoc['fullName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Stack(
      children: [
        Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(_fullName ?? 'جار التحميل...'),
                accountEmail: Text(authProvider.currentUser?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/tree.jpg'), 
                ),
              ),
              _createDrawerItem(
                icon: Icons.map,
                text: 'الخريطة',
                onTap: () => Navigator.pop(context), 
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
                onTap: () => Navigator.pop(context), // Replace with your navigation code
              ),
              _createDrawerItem(
                icon: Icons.explore,
                text: 'ابن بطوطة',
                onTap: () => Navigator.pop(context), // Replace with your navigation code
              ),
              _createDrawerItem(
                icon: Icons.help,
                text: 'الدليل',
                onTap: () => Navigator.pop(context), // Replace with your navigation code
              ),
              _createDrawerItem(
                icon: Icons.settings,
                text: 'الإعدادات',
                onTap: () => Navigator.pop(context), // Replace with your navigation code
              ),
              _createDrawerItem(
                icon: Icons.logout,
                text: 'تسجيل الخروج',
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final userId = authProvider.currentUser?.uid;
                  print('User $userId signed out');
                  await authProvider.signOut();
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()),); // Navigate to login page
                },
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
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
