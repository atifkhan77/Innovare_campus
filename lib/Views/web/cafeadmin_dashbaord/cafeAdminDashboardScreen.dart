import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manageOrdersScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manage_menuScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/viewOrdersScreen.dart';


class CafeAdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Admin Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5A5FF8), Color(0xFF6B78FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/admin_avatar.png'),
                      ),
                      SizedBox(width: 32),
                      Column(
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
                          Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Card Section
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCard(
                        icon: Icons.person,
                        label: 'Manage Menu',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManageMenuScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.fastfood,
                        label: 'Manage Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.list,
                        label: 'View Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewOrdersScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String label, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Container(
          width: 200,
          height: 200,
          padding: EdgeInsets.all(32),
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
