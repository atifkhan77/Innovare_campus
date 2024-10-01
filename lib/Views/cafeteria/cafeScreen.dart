import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:innovare_campus/Views/cafeteria/cartScreen.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CafeScreen extends StatefulWidget {
  @override
  _CafeScreenState createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
          title: const Text(
            'Cafeteria',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Fast Food'),
              Tab(text: 'Desi'),
              Tab(text: 'Drinks'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Splash.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search food',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildMenuGrid('Fast Food'),
                    _buildMenuGrid('Desi'),
                    _buildMenuGrid('Drinks'),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuGrid(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('menu')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final menuItems = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            var item = menuItems[index];
            var name = item['name'];
            var price = item['price'] is int
                ? (item['price'] as int).toDouble()
                : item['price'];
            var imageUrl = item['imageUrl'];

            return Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _getImageUrl(imageUrl),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Image.asset('assets/logo.png',
                              fit: BoxFit.cover);
                        } else {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/logo.png',
                                  fit: BoxFit.cover);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    '\$$price',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        item.id,
                        name,
                        price,
                        imageUrl,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name added to cart'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String> _getImageUrl(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        return await FirebaseStorage.instance.ref(imageUrl).getDownloadURL();
      }
      return '';
    } catch (e) {
      debugPrint('Error fetching image URL: $e');
      return '';
    }
  }
}
