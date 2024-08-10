import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          title: const Text('Cafeteria'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Fast Food'),
              Tab(text: 'Desi'),
              Tab(text: 'Drinks'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search food',
                  prefixIcon: Icon(Icons.search),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_cart),
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
          return Center(child: CircularProgressIndicator());
        }

        final menuItems = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            var item = menuItems[index];
            var name = item['name'];
            var price = item['price'];
            var imageUrl = item['imageUrl'];

            return Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrl.isEmpty
                          ? 'assets/placeholder.png'
                          : imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text('\$$price'),
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
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
                          duration: Duration(seconds: 2),
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
}
