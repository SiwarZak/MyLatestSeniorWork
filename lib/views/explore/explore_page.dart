import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/services/recombee_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tejwal/views/profile/profile_page.dart';
import 'dart:math';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.category},
    {'name': 'Nature', 'icon': Icons.nature},
    {'name': 'Cities', 'icon': Icons.location_city},
    {'name': 'Activities', 'icon': Icons.local_activity},
  ];
  String selectedCategory = 'All';

  List<Map<String, dynamic>> attractions = [];
  bool isLoading = true;
  Map<String, String> imageCache = {};

  @override
  void initState() {
    super.initState();
    fetchRandomAttractions();
  }

  Future<void> fetchRandomAttractions() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('attractions').get();
    final allAttractions = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Save the document ID
      return data;
    }).toList();
    allAttractions.shuffle(Random());
    setState(() {
      attractions = allAttractions.take(50).toList();
      isLoading = false;
    });
  }

  Future<String?> getDownloadUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.refFromURL(imagePath).getDownloadURL();
    } catch (e) {
      return null; // Return null if the image URL cannot be fetched
    }
  }

  Future<void> saveViewInteraction(String attractionId, String userId) async {
    // Save to Firestore
    await FirebaseFirestore.instance.collection('views').add({
      'item_id': attractionId,
      'user_id': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Save to Recombee
    final recombeeService = RecombeeService();
    await recombeeService.addInteraction(userId, attractionId);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.currentUser == null) {
      return Center(child: Text('Please log in to view attractions.'));
    }

    return Scaffold(
      body: Column(
        children: [
          // Categories Section
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index]['name'];
                      // Add filtering logic here 
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          categories[index]['icon'],
                          color: selectedCategory == categories[index]['name']
                              ? Colors.green
                              : Colors.black,
                        ),
                        SizedBox(width: 5), // Spacer between icon and text
                        Text(
                          categories[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedCategory == categories[index]['name']
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Images Grid Section
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns changed to 3
                      crossAxisSpacing: 4, // Horizontal space between items
                      mainAxisSpacing: 4, // Vertical space between items
                    ),
                    itemCount: attractions.length,
                    itemBuilder: (context, index) {
                      final attraction = attractions[index];
                      final imagePath = (attraction['images'] != null && attraction['images'].isNotEmpty)
                          ? attraction['images'][0]
                          : '';

                      if (imageCache.containsKey(imagePath)) {
                        return GestureDetector(
                          onTap: () async {
                            await saveViewInteraction(attraction['id'], authProvider.currentUser!.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Border radius added
                              image: DecorationImage(
                                image: NetworkImage(imageCache[imagePath]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 100,
                            width: 100,
                          ),
                        );
                      }

                      return FutureBuilder<String?>(
                        future: getDownloadUrl(imagePath),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/imagePlaceholder.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 100,
                              width: 100,
                            );
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/imagePlaceholder.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 100,
                              width: 100,
                            );
                          } else {
                            imageCache[imagePath] = snapshot.data!;
                            return GestureDetector(
                              onTap: () async {
                                await saveViewInteraction(attraction['id'], authProvider.currentUser!.uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 100,
                                width: 100,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
