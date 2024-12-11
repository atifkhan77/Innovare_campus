import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:innovare_campus/Views/Societies/clubs/societyDetailScreen.dart';

class SocietiesScreen extends StatelessWidget {
  const SocietiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of light colors for the cards
    final List<Color> cardColors = [
      Colors.lightBlue.shade100,
      Colors.lightGreen.shade100,
      Colors.amber.shade100,
      Colors.pink.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Societies',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
          iconTheme: const IconThemeData(color: Colors.white)),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png', // Adjust the path as per your directory structure
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('societies').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No societies found.'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Society society =
                      Society.fromDocument(snapshot.data!.docs[index]);
                  // Cycle through the list of colors
                  Color cardColor = cardColors[index % cardColors.length];

                  return Card(
                    color: cardColor, // Set the background color of the card
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SocietyDetailsScreen(society: society),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              society.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              society.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
