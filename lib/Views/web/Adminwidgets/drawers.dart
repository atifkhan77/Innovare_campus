import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/SocietiesManage/societyManagement.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/admin_dashboard.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/newsAnoouncement/newsManagementScreen.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/useraManage/usermanagementScreen.dart';
import 'package:innovare_campus/Views/web/admin_screen.dart';

class CustomDrawer extends StatelessWidget {
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
              children: [
                Image.asset('assets/logo.png', width: 80, height: 80),
                const SizedBox(height: 16),
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.person,
            label: 'Add Users/View Users',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserManagementScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.group,
            label: 'Societies',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SocietyManagementScreen(),
              ));
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.article,
            label: 'News',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsManagementScreen(),
              ));
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.perm_device_information_sharp,
            label: 'Lost and Found',
            onTap: () {},
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.dashboard,
            label: 'Dash Board',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminDashboardScreen(),
              ));
            },
          ),
          const Divider(), // Optional: adds a divider above the logout button
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {
              // Implement your logout logic here
              // e.g., clear user session, navigate to login screen, etc.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AdminScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromRGBO(49, 42, 119, 1),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Color.fromRGBO(49, 42, 119, 1),
        ),
      ),
      onTap: onTap,
    );
  }
}
