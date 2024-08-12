import 'package:flutter/material.dart';
import 'package:innovare_campus/model/lostfind.dart';

class ItemDetailScreen extends StatelessWidget {
  final LostFoundItem item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Padding(
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
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${item.location}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Timestamp: ${item.timestamp.toDate()}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
