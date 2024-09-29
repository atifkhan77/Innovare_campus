import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/cafeteria/orderTrackingScreen.dart';

class NotificationItem {
  final String message;
  final String status;

  NotificationItem({required this.message, required this.status});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const ChatBubble({Key? key, required this.message, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blueAccent, // Updated color for a modern look
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
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

      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('email', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestOrder = querySnapshot.docs.first;
        return latestOrder['orderNumber'] as String?;
      } else {
        print('No orders found for the user');
      }
    } catch (e) {
      print('Error fetching order: $e');
    }

    return null;
  }

  Future<List<NotificationItem>> _fetchTutoringStatusNotifications() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final userName =
        user.displayName; // Assuming displayName is used for matching
    if (userName == null) {
      return [];
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('studentName', isEqualTo: userName)
          .get();

      return querySnapshot.docs.map((doc) {
        return NotificationItem(
          message: doc['message'] as String,
          status: doc['status'] as String,
        );
      }).toList();
    } catch (e) {
      print('Error fetching tutoring notifications: $e');
      return [];
    }
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
          FutureBuilder<List<dynamic>>(
            future: Future.wait([
              _fetchLatestOrderNumber(),
              _fetchTutoringStatusNotifications(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                    child: Text('Error fetching notifications.'));
              }

              final orderNumber = snapshot.data![0] as String?;
              final tutoringNotifications =
                  snapshot.data![1] as List<NotificationItem>;

              return Padding(
                padding: const EdgeInsets.all(
                    16.0), // Added padding for better spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome to Innovare_Campus",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    if (orderNumber != null)
                      ChatBubble(
                        message:
                            "Your order is placed and your order number is $orderNumber",
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
                    const SizedBox(height: 10),
                    // Display tutoring notifications
                    Expanded(
                      child: ListView.builder(
                        itemCount: tutoringNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = tutoringNotifications[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ChatBubble(message: notification.message),
                              Text(
                                notification.status,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
