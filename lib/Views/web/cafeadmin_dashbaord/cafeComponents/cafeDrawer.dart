import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeAdminDashboardScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manageOrdersScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manage_menuScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/viewOrdersScreen.dart'; // Import the CafeAdminDashboardScreen

class CafeAdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(49, 42, 119, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    'assets/logo.png', // Add the path to your logo here
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Color.fromRGBO(49, 42, 119, 1),
            ),
            title: const Text(
              'Admin dashboard',
              style: TextStyle(
                color: Color.fromRGBO(49, 42, 119, 1),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CafeAdminDashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromRGBO(49, 42, 119, 1),
            ),
            title: const Text(
              'Manage Menu',
              style: TextStyle(
                color: Color.fromRGBO(49, 42, 119, 1),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageMenuScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.fastfood,
              color: Color.fromRGBO(49, 42, 119, 1),
            ),
            title: const Text(
              'Manage Orders',
              style: TextStyle(
                color: Color.fromRGBO(49, 42, 119, 1),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageOrderScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list,
              color: Color.fromRGBO(49, 42, 119, 1),
            ),
            title: const Text(
              'View Orders',
              style: TextStyle(
                color: Color.fromRGBO(49, 42, 119, 1),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewOrdersScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
