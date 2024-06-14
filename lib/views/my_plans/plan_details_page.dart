import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  
  final List<Map<String, dynamic>> places = [
    {
      'image': 'assets/images/tree.jpg',
      'location': 'Wadi al Qilt',
      'time': '15 min'
    },
    {
      'image': 'assets/images/tree.jpg',
      'location': 'Ein Harod',
      'time': '30 min'
    },
    {
      'image': 'assets/images/tree.jpg',
      'location': 'Jericho Village',
      'time': '40 min'
    },
    {
      'image': 'assets/images/tree.jpg',
      'location': 'Star Hotel',
      'time': '30 min'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'Tour Plan For Jericho',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Details'),
              Tab(text: 'General'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text('Details View')), // Placeholder for details view
                _buildGeneralView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralView() {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  _buildPlaceItem(places[index]),
                  if (index < places.length - 1)
                    _buildTimelineConnector(places[index + 1]['time']),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceItem(Map<String, dynamic> place) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40, 
            backgroundImage: AssetImage(place['image']),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          Text(place['location'], style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector(String time) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: CustomPaint(
            painter: _ConnectorPainter(),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 30,
          child: CustomPaint(
            painter: _ConnectorPainter(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class _ConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    // Draw the line
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
