import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:fl_chart/fl_chart.dart'; // For the Pie Chart

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

    // Fetch user data
    fetchUsersData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchUsersData() async {
    try {
      // Fetch all documents from the users collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      Map<String, int> tempCounts = {};

      // Loop through each document and extract regNo
      for (var doc in snapshot.docs) {
        String regNo = doc['regNo'];
        String prefix = regNo.substring(0, 4).toLowerCase(); // First four characters

        // Count occurrences of each prefix
        if (tempCounts.containsKey(prefix)) {
          tempCounts[prefix] = tempCounts[prefix]! + 1;
        } else {
          tempCounts[prefix] = 1;
        }
      }

      // Update the state with the counted prefixes
      setState(() {
        regNoCounts = tempCounts;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/admin_profile.png'),
                          ),
                          SizedBox(width: 24),
                          Column(
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
                    // Card Section and Pie Chart side by side
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cards Section
                          Expanded(
                            flex: 2,
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildAnimatedCard(
                                  icon: Icons.person,
                                  label: 'Add Users/View Users',
                                  onTap: () {
                                    // Navigate to user management screen
                                  },
                                ),
                                _buildAnimatedCard(
                                  icon: Icons.group,
                                  label: 'Societies',
                                  onTap: () {
                                    // Navigate to society management screen
                                  },
                                ),
                                _buildAnimatedCard(
                                  icon: Icons.article,
                                  label: 'News',
                                  onTap: () {
                                    // Navigate to news management screen
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Pie Chart Section
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 300,
                              child: regNoCounts.isEmpty
                                  ? Center(child: CircularProgressIndicator())
                                  : PieChart(
                                      PieChartData(
                                        sections: showingSections(),
                                        centerSpaceRadius: 40,
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 2,
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

  List<PieChartSectionData> showingSections() {
    if (regNoCounts.isEmpty) return [];

    final totalUsers = regNoCounts.values.reduce((a, b) => a + b);

    return regNoCounts.entries.map((entry) {
      final percentage = (entry.value / totalUsers) * 100;
      return PieChartSectionData(
        color: Colors.primaries[regNoCounts.keys.toList().indexOf(entry.key) %
            Colors.primaries.length],
        value: percentage,
        title: '${entry.key}: ${entry.value}',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildAnimatedCard({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value * 0.2 + 1, // Scale animation
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
