import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovare_campus/provider/cafeOrder_provider.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? initialOrderNumber;

  const OrderTrackingScreen({super.key, this.initialOrderNumber});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final TextEditingController _inputController = TextEditingController();
  Map<String, dynamic>? orderData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialOrderNumber != null) {
      _inputController.text = widget.initialOrderNumber!;
      _searchOrder();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<OrderProvider>(context);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

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
        orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('email', isEqualTo: input)
            .get();
      } else {
        orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('orderNumber', isEqualTo: input)
            .get();
      }

      if (orderSnapshot.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            orderData =
                orderSnapshot.docs.first.data() as Map<String, dynamic>?;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            orderData = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('No order found with this email or order number.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('An error occurred while searching for the order.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Your Order',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        elevation: 0,
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
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(49, 42, 119, 1),
                        Color(0xFF7E57C2),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      labelText: 'Enter your order number',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: isLoading ? null : _searchOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
                    shadowColor: const Color.fromRGBO(49, 42, 119, 0.6),
                    elevation: 8,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Track Order',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 24.0),
                if (orderData != null)
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: orderData != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.white.withOpacity(0.9),
                          elevation: 10,
                          shadowColor: const Color.fromRGBO(49, 42, 119, 0.6),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Status: ${orderData!['status'] ?? 'Unknown'}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromRGBO(49, 42, 119, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Total Payment: \$${orderData!['totalPayment']}',
                                    style: GoogleFonts.poppins(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Items:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  ...orderData!['items'].map<Widget>((item) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        '${item['name']} x ${item['quantity']}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14.0),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
