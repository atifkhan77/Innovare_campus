import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/Views/LostandFound/itemDetailScreen.dart';
import 'package:innovare_campus/Views/LostandFound/uploadItemScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key});

  @override
  _LostFoundScreenState createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  String? _profileImageUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshLostFoundItems();
    });
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      await _loadProfileImage();
    } else {
      print("No user is currently logged in");
    }
  }

  Future<void> _loadProfileImage() async {
    if (_userId == null) return;
    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(_userId);
      final doc = await docRef.get();
      if (doc.exists && doc['profile_image_url'] != null) {
        setState(() {
          _profileImageUrl = doc['profile_image_url'];
        });
      } else {
        setState(() {
          _profileImageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile image: $e');
    }
  }

  Future<void> _refreshLostFoundItems() async {
    await Provider.of<LostFoundProvider>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : const AssetImage('assets/placeholder.png') as ImageProvider,
            ),
            const SizedBox(width: 8),
            const Text(
              'Welcome',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Lost & Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadItemScreen()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Upload found or lost item',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<LostFoundProvider>(
                  builder: (context, provider, child) {
                    final items = provider.items;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetailScreen(item: item),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl.isEmpty
                                    ? 'https://via.placeholder.com/150'
                                    : item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
