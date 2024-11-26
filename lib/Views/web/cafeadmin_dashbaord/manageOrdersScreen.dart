import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/CafeteriaOrdersScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/PrintsScreen.dart';

class ManageOrderScreen extends StatelessWidget {
  const ManageOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png', // Path to your image
              fit: BoxFit.cover, // Adjust the image to cover the screen
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent, // Make Scaffold transparent
            appBar: AppBar(
              title: const Text(
                'Manage Orders',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                indicatorWeight: 4.0,
                tabs: [
                  Tab(text: 'Cafeteria Orders'),
                  Tab(text: 'Prints'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                CafeteriaOrdersScreen(),
                PrintsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
