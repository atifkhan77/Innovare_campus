import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/LostandFoundManage/EditLostFoundScreen.dart';
import 'package:innovare_campus/model/lostfind.dart';

class LostAndFoundScreen extends StatelessWidget {
  const LostAndFoundScreen({Key? key}) : super(key: key);

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('lost_found').doc(id).delete();
  }

  void editItem(BuildContext context, LostFoundItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditLostFoundScreen(item: item),
      ),
    );
  }

  // Method to launch the URL (open image in browser)
  void launchURL(String imageUrl) async {
    if (await canLaunch(imageUrl)) {
      await launch(imageUrl);
    } else {
      throw 'Could not launch $imageUrl';
    }
  }

  // Function to format timestamp into a readable string
  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Lost and Found',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/Splash.png"), // Add your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('lost_found').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items found.'));
            }

            final items = snapshot.data!.docs
                .map((doc) => LostFoundItem.fromDocument(doc))
                .toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: const Color.fromRGBO(
                      255, 255, 255, 0.8), // Semi-transparent white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  shadowColor: Colors.black.withOpacity(0.3),
                  elevation: 8,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => launchURL(
                          item.imageUrl), // Launch image URL in browser
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image),
                      ),
                    ),
                    title: Text(
                      item.description,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${item.location}',
                            style: const TextStyle(fontSize: 14)),
                        Text('Date: ${formatDate(item.timestamp)}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editItem(context, item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await deleteItem(item.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
