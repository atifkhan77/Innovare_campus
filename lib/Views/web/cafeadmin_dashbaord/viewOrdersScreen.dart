import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrdersScreen extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserDetails(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
        debugPrint('No user found with email: $email');
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Orders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders available.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final email = order['email'];
              final items = (order['items'] as List<dynamic>?) ?? [];

              return FutureBuilder<Map<String, dynamic>>(
                future: _fetchUserDetails(email),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Order Number: ${order['orderNumber']}'),
                        subtitle: const Text('Fetching user details...'),
                      ),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Order Number: ${order['orderNumber']}'),
                        subtitle: const Text('Error fetching user details'),
                      ),
                    );
                  }

                  final userData = userSnapshot.data ?? {};
                  final name = userData['name'] ?? 'Unknown Name';
                  final regNo = userData['regNo'] ?? 'Unknown RegNo';

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Order Number: ${order['orderNumber']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total: \$${order['totalPayment']}'),
                          Text('Email: ${order['email']}'),
                          Text('Name: $name'),
                          Text('RegNo: $regNo'),
                          ...items.map((item) {
                            final itemName = item['name'] ?? 'Unnamed Item';
                            final itemQuantity = item['quantity'] ?? 0;
                            return Text('$itemName x $itemQuantity');
                          }).toList(),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
