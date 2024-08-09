import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/newsManagementScreen.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/usermanagementScreen.dart';
import 'package:innovare_campus/provider/newsProvider.dart';
import 'package:provider/provider.dart';


class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.png'), // Background image
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/admin_profile.png'),
                      ),
                      SizedBox(width: 32),
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
                        ],
                      ),
                    ],
                  ),
                ),
                // Card Section with Wrap
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Wrap(
                    spacing: 16.0, // space between cards horizontally
                    runSpacing: 16.0, // space between cards vertically
                    children: [
                      _buildCard(
                        icon: Icons.person,
                        label: 'Add Users/View Users',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserManagementScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.local_cafe,
                        label: 'Cafe',
                        onTap: () {
                          // Navigate to Cafe screen
                        },
                      ),
                      _buildCard(
                        icon: Icons.group,
                        label: 'Societies',
                        onTap: () {
                          // Navigate to Societies screen
                        },
                      ),
                      _buildCard(
                        icon: Icons.article,
                        label: 'News',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsManagementScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon, required String label, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
