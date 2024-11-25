import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/cafeteria/orderTrackingScreen.dart';
import 'package:innovare_campus/provider/cafeOrder_provider.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:innovare_campus/model/cafeOrder.dart';
import 'package:innovare_campus/stripe/stripe.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) {
              var cartItem = cart.items.values.toList()[index];
              return Card(
                color: Colors.transparent,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      cartItem.imageUrl.isEmpty
                          ? 'assets/logo.png'
                          : cartItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/logo.png');
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
                          _showSnackbar(context,
                              'Decreased quantity of ${cartItem.name}');
                        },
                      ),
                      Expanded(
                        child: Text(
                          ' ${cartItem.quantity}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
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
                          _showSnackbar(context,
                              'Increased quantity of ${cartItem.name}');
                        },
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
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
                            _showSnackbar(
                                context, '${cartItem.name} removed from cart');
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
                      MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen()),
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

  void _showSnackbar(BuildContext context, String message) {
    if (Navigator.canPop(context)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
              Navigator.of(context).pop();
              _handleCashPayment(context, cart);
            },
            child: const Text('Pay with Cash'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _handleOnlinePayment(context, cart);
            },
            child: const Text('Pay Online'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleOnlinePayment(
      BuildContext context, CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showSnackbar(context, 'User not logged in.');
      return;
    }

    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final totalPayment = cart.totalAmount;

    final order = OrderConfirmation(
      id: '',
      email: user.email ?? 'Unknown User',
      orderNumber: orderNumber,
      totalPayment: totalPayment,
      items: cart.items.values
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
                'imageUrl': item.imageUrl,
              })
          .toList(),
      paymentMethod: 'Online',
      timestamp: DateTime.now(),
    );

    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .placeOrder(order);
      await StripeService.instance.makePayment('Comsats Cafeteria',
          (totalPayment * 100).toInt(), user.email ?? 'Unknown User');

      cart.clearCart();

      _showSnackbar(context, 'Order placed successfully!');
    } catch (error) {
      _showSnackbar(context, 'Failed to place order: $error');
    }
  }

  void _handleCashPayment(BuildContext context, CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showSnackbar(context, 'User not logged in.');
      return;
    }

    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final totalPayment = cart.totalAmount;

    final order = OrderConfirmation(
      id: '',
      email: user.email ?? 'Unknown User',
      orderNumber: orderNumber,
      totalPayment: totalPayment,
      items: cart.items.values
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
                'imageUrl': item.imageUrl,
              })
          .toList(),
      paymentMethod: 'Cash',
      timestamp: DateTime.now(),
    );

    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .placeOrder(order);
      cart.clearCart();

      _showSnackbar(context, 'Order placed successfully!');
    } catch (error) {
      _showSnackbar(context, 'Failed to place order: $error');
    }
  }
}
