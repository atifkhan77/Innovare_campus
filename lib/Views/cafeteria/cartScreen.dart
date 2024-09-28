import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/cafeteria/orderTrackingScreen.dart';
import 'package:innovare_campus/provider/cafeOrder_provider.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:innovare_campus/model/cafeOrder.dart';
import 'package:innovare_campus/stripe/stripe.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash.png'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Cart items
          ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) {
              var cartItem = cart.items.values.toList()[index];
              return Card(
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      cartItem.imageUrl.isEmpty
                          ? 'assets/logo.png' // Placeholder image
                          : cartItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/logo.png'); // Fallback in case of an error
                      },
                    ),
                  ),
                  title: Text(
                    cartItem.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          cart.removeSingleItem(cartItem.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Decreased quantity of ${cartItem.name}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          ' ${cartItem.quantity}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center, // Center align for better layout
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          cart.addItem(
                            cartItem.id,
                            cartItem.name,
                            cartItem.price,
                            cartItem.imageUrl,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Increased quantity of ${cartItem.name}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100, // Set a fixed width for the trailing widget
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${cartItem.price * cartItem.quantity}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            cart.removeItem(cartItem.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${cartItem.name} removed from cart',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(49, 42, 119, 1),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Total: \$${cart.totalAmount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showPaymentOptions(context, cart);
                  },
                  child: const Text('Checkout'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderTrackingScreen()),
                    );
                  },
                  child: const Text('Order Tracking'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Options'),
        content: const Text('Choose your payment method.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _handleCashPayment(context, cart);
            },
            child: const Text('Pay with Cash'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _handleOnlinePayment(context, cart);
            },
            child: const Text('Pay Online'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleOnlinePayment(BuildContext context, CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not logged in.'),
        ),
      );
      return;
    }

    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final totalPayment = cart.totalAmount;

    final order = OrderConfirmation(
      id: '', // ID will be assigned by Firestore
      email: user.email ?? 'Unknown User', // Use user.email
      orderNumber: orderNumber,
      totalPayment: totalPayment,
      items: cart.items.values.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
      }).toList(),
      paymentMethod: 'Online',
      timestamp: DateTime.now(),
    );

    try {
      await Provider.of<OrderProvider>(context, listen: false).placeOrder(order);
      await StripeService.instance.makePayment('Comsats Cafeteria', (totalPayment * 100).toInt(), user.email ?? 'Unknown User');

      cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $error'),
        ),
      );
    }
  }

  void _handleCashPayment(BuildContext context, CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not logged in.'),
        ),
      );
      return;
    }

    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final totalPayment = cart.totalAmount;

    final order = OrderConfirmation(
      id: '', // ID will be assigned by Firestore
      email: user.email ?? 'Unknown User', // Use user.email
      orderNumber: orderNumber,
      totalPayment: totalPayment,
      items: cart.items.values.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
      }).toList(),
      paymentMethod: 'Cash',
      timestamp: DateTime.now(),
    );

    try {
      await Provider.of<OrderProvider>(context, listen: false).placeOrder(order);

      cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $error'),
        ),
      );
    }
  }
}
