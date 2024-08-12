import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';

class SocietyDetailsScreen extends StatelessWidget {
  final Society society;

  SocietyDetailsScreen({required this.society});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(society.name),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(society.description),
            SizedBox(height: 8.0),
            Text('Recruitment Drive:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(society.recruitmentDrive),
            SizedBox(height: 8.0),
            Text('Upcoming Event:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(society.upcomingEvent),
          ],
        ),
      ),
    );
  }
}
