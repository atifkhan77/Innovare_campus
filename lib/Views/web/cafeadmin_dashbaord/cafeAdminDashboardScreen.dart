import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeComponents/cafeDrawer.dart'; // Import the drawer

class CafeAdminDashboardScreen extends StatefulWidget {
  @override
  _CafeAdminDashboardScreenState createState() =>
      _CafeAdminDashboardScreenState();
}

class _CafeAdminDashboardScreenState extends State<CafeAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, int> orderStatusCount = {
    'Pending': 0,
    'In Process': 0,
    'Completed': 0,
  };

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

    _fetchOrderStatusCount(); // Fetch the order status data
  }

  Future<void> _fetchOrderStatusCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final orders = snapshot.docs;

    Map<String, int> statusCount = {
      'Pending': 0,
      'In Process': 0,
      'Completed': 0,
    };

    for (var order in orders) {
      String status = order.data()['status'] ?? 'Pending';
      if (statusCount.containsKey(status)) {
        statusCount[status] = statusCount[status]! + 1;
      }
    }

    setState(() {
      orderStatusCount = statusCount;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(79, 76, 116, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CafeAdminDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: -0.2,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/logo.png',
                width: 800,
                height: 800,
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
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
                                'Cafe Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Manage your operations',
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
                    // Add one chart and two placeholders in a row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: _buildChartsRow(), // Call the row of charts
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

  // Function to build one chart and two empty placeholders in a row
  Widget _buildChartsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Orders status chart
        _buildOrderStatusBarChart(),

        // Placeholder 1
        _buildPlaceholderChart('Placeholder 1'),

        // Placeholder 2
        _buildPlaceholderChart('Placeholder 2'),
      ],
    );
  }

  // Function to build the order status bar chart
  Widget _buildOrderStatusBarChart() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Order Status Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['Pending']!.toDouble(),
                            color: Colors.orange,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['In Process']!.toDouble(),
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['Completed']!.toDouble(),
                            color: Colors.green,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Pending');
                              case 1:
                                return const Text('In Process');
                              case 2:
                                return const Text('Completed');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          interval: 1,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build placeholder chart
  Widget _buildPlaceholderChart(String title) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
