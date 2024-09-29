import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Chart package
import 'package:innovare_campus/Views/web/Adminwidgets/drawers.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/SocietiesManage/societyManagement.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/newsAnoouncement/newsManagementScreen.dart';
import 'package:innovare_campus/Views/web/Adminwidgets/piechart.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Map<String, int> regNoCounts = {};
  List<FlSpot> userGrowthData = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    fetchUsersData();
    fetchUserGrowthData(); // Fetch area chart data
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      Map<String, int> tempCounts = {};
      for (var doc in snapshot.docs) {
        String regNo = doc['regNo'];
        String prefix = regNo.substring(0, 4).toLowerCase();

        if (tempCounts.containsKey(prefix)) {
          tempCounts[prefix] = tempCounts[prefix]! + 1;
        } else {
          tempCounts[prefix] = 1;
        }
      }

      setState(() {
        regNoCounts = tempCounts;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserGrowthData() async {
    // Simulating user growth data for the area chart
    List<FlSpot> tempData = [
      FlSpot(0, 10), // Month 1, 10 users
      FlSpot(1, 20), // Month 2, 20 users
      FlSpot(2, 40), // Month 3, 40 users
      FlSpot(3, 80), // Month 4, 80 users
    ];

    setState(() {
      userGrowthData = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png',
              fit: BoxFit.cover,
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(width: 24),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildCard(
                              title: 'Users by Category',
                              child: regNoCounts.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : CustomPieChart(regNoCounts: regNoCounts),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildCard(
                              title: 'User Growth Over Time',
                              child: userGrowthData.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _buildAreaChart(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildCard(
                              title: 'Third Chart',
                              child: const Center(
                                child: Text(
                                  'Placeholder for Third Chart',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: userGrowthData,
            isCurved: true,
            color: Colors.blueAccent.withOpacity(0.6),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withOpacity(0.3),
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(49, 42, 119, 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Changes the position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }
}
