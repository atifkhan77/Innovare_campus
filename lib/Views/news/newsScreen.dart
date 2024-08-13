import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchNews() async {
    try {
      final querySnapshot = await _firestore.collection('news').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Failed to load news: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No announcements available'));
          } else {
            final newsItems = snapshot.data!;
            return ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final news = newsItems[index];
                return ListTile(
                  title: Text(news['title'] ?? 'No title'),
                  subtitle: Text(news['content'] ?? 'No content'),
                  leading: news['image_url'] != null
                      ? Image.network(news['image_url'])
                      : null,
                );
              },
            );
          }
        },
      ),
    );
  }
}
