import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/cafeteria/orderTrackingScreen.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final VoidCallback? onTap; // Add onTap callback

  const ChatBubble({Key? key, required this.message, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call onTap when tapped
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  Future<String?> _fetchLatestOrderNumber() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not logged in');
        return null;
      }

      final userEmail = user.email;
      if (userEmail == null) {
        print('User email is null');
        return null;
      }

      print('Fetching orders for email: $userEmail');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('email', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestOrder = querySnapshot.docs.first;
        final orderNumber = latestOrder['orderNumber'] as String?;
        print('Latest order number: $orderNumber');
        return orderNumber;
      } else {
        print('No orders found for the user');
      }
    } catch (e) {
      print('Error fetching order: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Splash.png", // Background image
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<String?>(
            future: _fetchLatestOrderNumber(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print('Snapshot error: ${snapshot.error}');
                return const Center(child: Text('Error fetching order.'));
              }

              final orderNumber = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: const ChatBubble(
                      message: "Welcome to Innovare_Campus",
                    ),
                  ),
                  if (orderNumber != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ChatBubble(
                        message: "Your order is placed and your order number is $orderNumber",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingScreen(
                                initialOrderNumber: orderNumber,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Expanded(child: Container()), // This ensures the Column fills the remaining space
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
