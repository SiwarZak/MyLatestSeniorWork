import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, String>> favorites = [
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg', 
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
    {
      'name': 'سوبرلاند',
      'city': 'أريحا',
      'image': 'assets/images/tree.jpg',
    },
  ];

  FavoritesPage({super.key});

  void onArrowTap(BuildContext context, String attractionName) {
    // Define the action to perform when the arrow is clicked
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clicked on $attractionName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مفضلاتي',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4), 
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white, 
                    margin: const EdgeInsets.symmetric(vertical: 4.0), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.green, // Green border
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          favorites[index]['image']!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        favorites[index]['name']!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        favorites[index]['city']!,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                          size: 20,
                        ),
                        onPressed: () => onArrowTap(context, favorites[index]['name']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
