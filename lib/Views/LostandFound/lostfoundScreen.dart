import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/LostandFound/itemDetailScreen.dart';
import 'package:innovare_campus/Views/LostandFound/uploadItemScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';


class LostFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_picture.png'), // Placeholder for profile picture
            ),
            SizedBox(width: 8),
            Text(
              'Welcome back, User', // Replace with dynamic user name
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4D1DFF), Color(0xFF4D79FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
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
                  MaterialPageRoute(builder: (context) => UploadItemScreen()),
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
                                  ? 'https://via.placeholder.com/150' // Placeholder URL
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
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
