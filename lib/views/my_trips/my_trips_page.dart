import 'package:flutter/material.dart';

class MyTripsPage extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {
      'name': 'رحلة استجمام',
      'description': 'استمتع بيوم هادئ بعيدًا عن صخب المدينة.',
      'image': 'assets/images/tree.jpg', 
      'date': '25 مارس',
      'day': 'السبت'
    },
    {
      'name': 'رحلة تاريخية',
      'description': 'اكتشف آثار المدينة القديمة وتاريخها العريق.',
      'image': 'assets/images/tree.jpg',
      'date': '10 ابريل',
      'day': 'الاثنين'
    },
    {
      'name': 'رحلة مغامرة',
      'description': 'استعد للمغامرة والتشويق في رحلة لا تُنسى.',
      'image': 'assets/images/tree.jpg',
      'date': '1 مايو',
      'day': 'الخميس'
    },
    {
      'name': 'رحلة ثقافية',
      'description': 'استمتع بالعروض الثقافية والتراثية المميزة.',
      'image': 'assets/images/tree.jpg',
      'date': '15 يونيو',
      'day': 'الجمعة'
    },
    {
      'name': 'رحلة طبيعية',
      'description': 'استكشف جمال الطبيعة وسحر المناظر الخلابة.',
      'image': 'assets/images/tree.jpg',
      'date': '30 يوليو',
      'day': 'الأحد'
    },
  ];

  void onTripTap(BuildContext context, String tripName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clicked on $tripName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Text(
                'رحلاتي',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          trips[index]['image']!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        trips[index]['name']!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trips[index]['description']!,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.black54,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                trips[index]['day']!,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                trips[index]['date']!,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                          size: 20,
                        ),
                        onPressed: () => onTripTap(context, trips[index]['name']!),
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
