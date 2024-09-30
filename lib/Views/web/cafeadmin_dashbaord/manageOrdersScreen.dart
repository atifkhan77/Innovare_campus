import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/CafeteriaOrdersScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/PrintsScreen.dart';

class ManageOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Orders',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
          bottom: const TabBar(
            labelColor: Colors.white, // Color of the selected tab text
            unselectedLabelColor: Colors.grey, // Color of unselected tab text
            indicatorColor: Colors.white, // Color of the tab indicator
            indicatorWeight: 4.0, // Thickness of the tab indicator
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
    );
  }
}
