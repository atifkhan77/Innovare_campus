import 'package:flutter/material.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.itemCount,
        itemBuilder: (context, index) {
          var cartItem = cart.items.values.toList()[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: Image.network(
                cartItem.imageUrl.isEmpty
                    ? 'assets/placeholder.png'  // Placeholder image
                    : cartItem.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(cartItem.name),
              subtitle: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cart.removeSingleItem(cartItem.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Decreased quantity of ${cartItem.name}'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  Text('Quantity: ${cartItem.quantity}'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      cart.addItem(
                          cartItem.id, cartItem.name, cartItem.price, cartItem.imageUrl);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Increased quantity of ${cartItem.name}'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${cartItem.price * cartItem.quantity}'),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      cart.removeItem(cartItem.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${cartItem.name} removed from cart'),
                          duration: Duration(seconds: 2),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${cart.totalAmount}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle checkout logic here
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
