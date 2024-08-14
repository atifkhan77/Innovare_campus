import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatefulWidget {
  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final TextEditingController _inputController = TextEditingController();
  Map<String, dynamic>? orderData;
  bool isLoading = false;

  Future<void> _searchOrder() async {
    String input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      isLoading = true;
      orderData = null;
    });

    QuerySnapshot orderSnapshot;
    try {
      if (input.contains('@')) {
        // Search by email
        orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('email', isEqualTo: input)
            .get();
      } else {
        // Search by order number
        orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('orderNumber', isEqualTo: input)
            .get();
      }

      if (orderSnapshot.docs.isNotEmpty) {
        setState(() {
          orderData = orderSnapshot.docs.first.data() as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          orderData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No order found with this email or order number.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while searching for the order.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Order'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter your email or order number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isLoading ? null : _searchOrder,
              child: isLoading ? CircularProgressIndicator() : Text('Track Order'),
            ),
            SizedBox(height: 16.0),
            if (orderData != null) ...[
              Text(
                'Order Status: ${orderData!['status']}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Payment: \$${orderData!['totalPayment']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Items:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              ...orderData!['items'].map<Widget>((item) {
                return Text('${item['name']} x ${item['quantity']}');
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
