import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintsScreen extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserDetailsByUserID(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Use doc() to fetch user by document ID
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!;
      } else {
        print('No user found with userId: $userId');
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }

  void _downloadDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('prints').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No documents available.'));
        }

        final documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index].data() as Map<String, dynamic>;
            final url = document['url'];
            final userId = document['userId']; // Use userId here

            return FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserDetailsByUserID(userId),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingCard();
                }

                if (userSnapshot.hasError) {
                  return _buildErrorCard();
                }

                final userData = userSnapshot.data ?? {};
                final name = userData['name'] ?? 'Unknown Name';
                final regNo = userData['regNo'] ?? 'Unknown RegNo';

                return _buildDocumentCard(url, name, regNo);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Fetching user details...'),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Error fetching user details'),
      ),
    );
  }

  Widget _buildDocumentCard(String url, String name, String regNo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Document uploaded by $name (RegNo: $regNo)'),
        subtitle: Text('File URL: $url'),
        trailing: IconButton(
          icon: Icon(Icons.download),
          onPressed: () {
            if (url.isNotEmpty) {
              _downloadDocument(url);
            } else {
              print('No URL provided for download');
            }
          },
        ),
      ),
    );
  }
}
