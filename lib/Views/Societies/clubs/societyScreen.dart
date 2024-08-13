import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:innovare_campus/Views/Societies/clubs/societyDetailScreen.dart';

class SocietiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Societies'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('societies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No societies found.'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two cards per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Society society =
                  Society.fromDocument(snapshot.data!.docs[index]);
              return Card(
                child: ListTile(
                  title: Text(society.name),
                  subtitle: Text(society.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SocietyDetailsScreen(society: society),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
