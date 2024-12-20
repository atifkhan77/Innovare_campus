import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeteriaOrdersScreen extends StatelessWidget {
  const CafeteriaOrdersScreen({super.key});

  Future<Map<String, dynamic>> _fetchUserDetailsByEmail(String email) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first.data();
      } else {
        print('No user found with email: $email');
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
            final order = orders[index];
            final orderData = order.data() as Map<String, dynamic>;
            final email = orderData['email'];
            final items = (orderData['items'] as List<dynamic>?) ?? [];
            final status = orderData['status'] ?? 'Pending';

            return FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserDetailsByEmail(email),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingCard(orderData);
                }

                if (userSnapshot.hasError) {
                  return _buildErrorCard(orderData);
                }

                final userData = userSnapshot.data ?? {};
                final name = userData['name'] ?? 'Unknown Name';
                final regNo = userData['regNo'] ?? 'Unknown RegNo';

                return _buildOrderCard(
                    order.id, orderData, items, name, regNo, status, context);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingCard(Map<String, dynamic> orderData) {
    return Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          'Order Number: ${orderData['orderNumber']}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text('Fetching user details...'),
        tileColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildErrorCard(Map<String, dynamic> orderData) {
    return Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          'Order Number: ${orderData['orderNumber']}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text('Error fetching user details'),
        tileColor: Colors.red[100],
      ),
    );
  }

  Widget _buildOrderCard(
      String orderId,
      Map<String, dynamic> orderData,
      List<dynamic> items,
      String name,
      String regNo,
      String status,
      BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 42, 119, 1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          'Order Number: ${orderData['orderNumber']}',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \$${orderData['totalPayment']}',
              style: TextStyle(color: Colors.white),
            ),
            Text('User: $name (RegNo: $regNo)',
                style: TextStyle(color: Colors.white70)),
            Text('Status: $status',
                style: TextStyle(color: _getStatusColor(status))),
            ...items.map((item) {
              final itemName = item['name'] ?? 'Unnamed Item';
              final itemQuantity = item['quantity'] ?? 0;
              return Text('$itemName x $itemQuantity',
                  style: TextStyle(color: Colors.white70));
            }),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete') {
              _deleteOrder(orderId);
            } else {
              _updateOrderStatus(orderId, value);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: 'Pending', child: Text('Pending')),
              const PopupMenuItem(
                  value: 'In Process', child: Text('In Process')),
              const PopupMenuItem(value: 'Completed', child: Text('Completed')),
              const PopupMenuItem(value: 'Delete', child: Text('Delete')),
            ];
          },
          icon: const Icon(Icons.more_vert, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Process':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
