import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';

class UserInterestsPage extends StatefulWidget {
  @override
  _UserInterestsPageState createState() => _UserInterestsPageState();
}

class _UserInterestsPageState extends State<UserInterestsPage> {
  List<Map<String, dynamic>> interests = [
    {"name": "تل", "icon": Icons.terrain},
    {"name": "تاريخ", "icon": Icons.history},
    {"name": "طبيعة", "icon": Icons.nature},
    {"name": "منتزه", "icon": Icons.park},
    {"name": "بحيرات", "icon": Icons.pool},
    {"name": "ملاهي", "icon": Icons.attractions},
    {"name": "جبال", "icon": Icons.landscape},
    {"name": "موقع ديني", "icon": Icons.account_balance},
    {"name": "متحف", "icon": Icons.museum},
  ];

  List<String> cities = [
    "جنين",
    "رام الله",
    "أريحا",
    "نابلس",
    "طولكرم",
    "بيت لحم",
    "يافا",
    "القدس",
    "عكا",
    "الخليل",
  ];

  List<String> selectedInterests = [];
  String? selectedCity;

  void toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  Widget buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'ما هي مدينتك الحالية؟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 300,
              child: DropdownSearch<String>(
                items: cities,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ابحث عن مدينتك',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "اختر مدينتك",
                    hintText: "ابحث عن مدينتك",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                selectedItem: selectedCity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInterestGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: interests.map((interest) {
          return GestureDetector(
            onTap: () => toggleSelection(interest["name"]),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedInterests.contains(interest["name"])
                      ? Colors.green
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(interest["icon"], size: 50, color: Colors.orange),
                  SizedBox(height: 10),
                  Text(
                    interest["name"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildContinueButton(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final user = authProvider.currentUser;
            if (user != null && selectedCity != null) {
              await authProvider.updateUserData(
                interests: selectedInterests,
                city: selectedCity!,
                onSuccess: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationbar()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User data saved successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to save user data: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select a city and interests.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save user data: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.green, width: 2),
          ),
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'استمرار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, size: 24, color: Colors.green),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            buildCityDropdown(),
            SizedBox(height: 20),
            Center(
              child: Text(
                'ما هي الأنشطة التي تفضلها',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            buildInterestGrid(),
            buildContinueButton(context, authProvider),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
