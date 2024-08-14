import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'package:innovare_campus/provider/cafeOrder_provider.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:innovare_campus/model/cafeOrder.dart';

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
                  leading: Image.network(
                    cartItem.imageUrl.isEmpty
                        ? 'assets/placeholder.png' // Placeholder image
                        : cartItem.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
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
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      Text(
                        'Quantity: ${cartItem.quantity}',
                        style: const TextStyle(color: Colors.white),
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
                  trailing: Row(
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
            Text(
              'Total: \$${cart.totalAmount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showPaymentOptions(context, cart);
              },
              child: const Text('Checkout'),
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
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Handle online payment here
            },
            child: const Text('Pay Online'),
          ),
        ],
      ),
    );
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
    email: user.displayName ?? user.email ?? 'Unknown User',
    
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
  );

  try {
    // Save order to Firestore
    await Provider.of<OrderProvider>(context, listen: false).placeOrder(order);

    // Clear the cart
    cart.clearCart();

    // Show a confirmation message
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