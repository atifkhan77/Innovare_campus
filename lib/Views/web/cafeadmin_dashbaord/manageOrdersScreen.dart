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
          title: const Text('Manage Orders'),
          backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
          bottom: TabBar(
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
