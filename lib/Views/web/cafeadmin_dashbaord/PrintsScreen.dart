import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintsScreen extends StatelessWidget {
  const PrintsScreen({super.key});

  Future<Map<String, dynamic>> _fetchUserDetailsByUserID(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!;
      } else {
        debugPrint('No user found with userId: $userId');
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return {};
    }
  }

  void _downloadDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('prints').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No documents available.'));
        }

        final documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index].data() as Map<String, dynamic>;
            final url = document['url'];
            final userId = document['userId'];

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
    return const Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          'Fetching user details...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return const Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          'Error fetching user details',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String url, String name, String regNo) {
    return Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          'Document uploaded by $name \n (RegNo: $regNo)',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'File URL: $url',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.download,
          ),
          onPressed: () {
            if (url.isNotEmpty) {
              _downloadDocument(url);
            } else {
              debugPrint('No URL provided for download');
            }
          },
        ),
      ),
    );
  }
}
