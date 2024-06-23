// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tejwal/providers/auth_provider.dart' as provider;
// import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';

// class UserInterestsPage extends StatefulWidget {
//   final User user; // Accept the user object

//   UserInterestsPage({required this.user});
//   @override
//   _UserInterestsPageState createState() => _UserInterestsPageState();
// }

// class _UserInterestsPageState extends State<UserInterestsPage> {
//   List<Map<String, dynamic>> interests = [
//     {"name": "تل", "icon": Icons.terrain},
//     {"name": "تاريخ", "icon": Icons.history},
//     {"name": "طبيعة", "icon": Icons.nature},
//     {"name": "منتزه", "icon": Icons.park},
//     {"name": "بحيرات", "icon": Icons.pool},
//     {"name": "ملاهي", "icon": Icons.attractions},
//     {"name": "جبال", "icon": Icons.landscape},
//     {"name": "موقع ديني", "icon": Icons.account_balance},
//     {"name": "متحف", "icon": Icons.museum},
//   ];

//   List<String> cities = [
//     "جنين",
//     "رام الله",
//     "أريحا",
//     "نابلس",
//     "طولكرم",
//     "بيت لحم",
//     "يافا",
//     "القدس",
//     "عكا",
//     "الخليل",
//   ];

//   List<String> selectedInterests = [];
//   String? selectedCity;

//   void toggleSelection(String interest) {
//     setState(() {
//       if (selectedInterests.contains(interest)) {
//         selectedInterests.remove(interest);
//       } else {
//         selectedInterests.add(interest);
//       }
//     });
//   }

//   Widget buildCityDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Center(
//             child: Text(
//               'ما هي مدينتك الحالية؟',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Center(
//             child: SizedBox(
//               width: 300,
//               child: DropdownSearch<String>(
//                 items: cities,
//                 popupProps: PopupProps.menu(
//                   showSearchBox: true,
//                   searchFieldProps: TextFieldProps(
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search),
//                       hintText: 'ابحث عن مدينتك',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     ),
//                   ),
//                   constraints: const BoxConstraints(
//                     maxHeight: 300,
//                   ),
//                 ),
//                 dropdownDecoratorProps: DropDownDecoratorProps(
//                   dropdownSearchDecoration: InputDecoration(
//                     labelText: "اختر مدينتك",
//                     hintText: "ابحث عن مدينتك",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCity = value;
//                   });
//                 },
//                 selectedItem: selectedCity,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildInterestGrid() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: GridView.count(
//         crossAxisCount: 3,
//         mainAxisSpacing: 20,
//         crossAxisSpacing: 20,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         children: interests.map((interest) {
//           return GestureDetector(
//             onTap: () => toggleSelection(interest["name"]),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: selectedInterests.contains(interest["name"])
//                       ? Colors.green
//                       : Colors.transparent,
//                   width: 3,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(interest["icon"], size: 50, color: Colors.orange),
//                   const SizedBox(height: 10),
//                   Text(
//                     interest["name"],
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget buildContinueButton(BuildContext context, AuthProvider authProvider) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: ElevatedButton(
//         onPressed: () async {
//           try {
//             final user = provider.AuthProvider.currentUser;
//             if (user != null && selectedCity != null) {
//               await provider.AuthProvider.updateUserData(
//                 interests: selectedInterests,
//                 city: selectedCity!,
//                 onSuccess: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const BottomNavigationbar()),
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('User data saved successfully!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 onError: (error) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to save user data: $error'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 },
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Please select a city and interests.'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Failed to save user data: $e'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: Colors.green, width: 2),
//           ),
//           backgroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'استمرار',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//             SizedBox(width: 10),
//             Icon(Icons.arrow_forward, size: 24, color: Colors.green),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             buildCityDropdown(),
//             const SizedBox(height: 20),
//             const Center(
//               child: Text(
//                 'ما هي الأنشطة التي تفضلها',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//             buildInterestGrid(),
//             buildContinueButton(context, authProvider),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart' as auth;
import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';

class UserInterestsPage extends StatefulWidget {
  const UserInterestsPage({super.key});


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

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
    authProvider.currentUser!; // Set the current user here
  }

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
          const Center(
            child: Text(
              'ما هي مدينتك الحالية؟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 300,
              child: DropdownSearch<String>(
                items: cities,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'ابحث عن مدينتك',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  constraints: const BoxConstraints(
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                boxShadow: const [
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
                  const SizedBox(height: 10),
                  Text(
                    interest["name"],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildContinueButton(BuildContext context, auth.AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (selectedCity != null) {
              await authProvider.updateUserData(
                interests: selectedInterests,
                city: selectedCity!,
                onSuccess: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationbar()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
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
                const SnackBar(
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
            side: const BorderSide(color: Colors.green, width: 2),
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        ),
        child: const Row(
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
    final authProvider = Provider.of<auth.AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            buildCityDropdown(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'ما هي الأنشطة التي تفضلها',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            buildInterestGrid(),
            buildContinueButton(context, authProvider),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
