import 'package:flutter/material.dart';
import 'package:innovare_campus/model/lostfind.dart';

class ItemDetailScreen extends StatelessWidget {
  final LostFoundItem item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash.png'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    item.imageUrl.isEmpty
                        ? 'https://via.placeholder.com/150' // Placeholder URL
                        : item.imageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description: ${item.description}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Adjust text color for visibility
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${item.location}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Adjust text color for visibility
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Timestamp: ${item.timestamp.toDate()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Adjust text color for visibility
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
