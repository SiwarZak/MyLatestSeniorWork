import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.nature, 'label': 'Nature'},
    // Add other categories here
  ];

  final List<Map<String, dynamic>> trips = [
    {
      'companyName': 'Tejwal',
      'placeName': 'Beautiful Resort',
      'date': '2024-01-30',
      'fee': '100 SAR',
      'departureTime': '07:30 PM',
      'pictures': [
        'assets/images/tree.jpg',
        'assets/images/tree.jpg',
        'assets/images/tree.jpg',
      ],
      // Add more trip details 
    },
    // Add other trips here
  ];

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategories(),
          _buildTripPosts(),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          var category = categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
                // Implement filtering logic
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: _selectedCategoryIndex == index
                    ? Colors.green[100]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedCategoryIndex == index
                      ? Colors.green
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(category['icon'],
                      color: _selectedCategoryIndex == index
                          ? Colors.green
                          : Colors.grey),
                  const SizedBox(width: 8),
                  Text(category['label']),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTripPosts() {
    return Column(
      children: trips.map((trip) => TripWidget(tripData: trip)).toList(),
    );
  }
}

class TripWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripWidget({super.key, required this.tripData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/img_login_page.png'),
              
            ),
            title: Text(tripData['companyName']),
            subtitle: Text(tripData['placeName']),
            trailing: const Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.calendar_today, tripData['date']),
                _buildDetailRow(Icons.money_off_csred_rounded, tripData['fee']),
                _buildDetailRow(Icons.timer, tripData['departureTime']),
              ],
            ),
          ),
          _buildImageGrid(tripData['pictures']),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButtons(),
                _buildRegisterButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: Colors.green),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> pictureUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: pictureUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.asset(
          pictureUrls[index],
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.green),
          onPressed: () {
            // Implement function
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.green),
          onPressed: () {
            // Implement function
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.green),
          onPressed: () {
            // Implement  function
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement registration functionality
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      child: const Text('Register'),
    );
  }
}
