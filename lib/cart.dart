// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartItems = [];
  List orders = []; // List to store fetched orders
  Map<String, dynamic>? user; // To store user details
  bool showOrders = false; // Flag to control showing orders

  @override
  void initState() {
    super.initState();
    retrieveCartItems();
    retrieveAuthToken();
  }

  Future<void> retrieveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cart = prefs.getString('cart');
    if (cart != null) {
      setState(() {
        cartItems = json.decode(cart);
      });
    }
  }

  Future<void> retrieveAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    String? email = prefs.getString('email');

    if (authToken != null && email != null) {
      fetchUser(authToken, email);
    } else {
    }
  }

  Future<void> fetchUser(String authToken, String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/users'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        List users = json.decode(response.body)['data'];
        for (var u in users) {
          if (u['email'] == email) {
            setState(() {
              user = u;
            });
            break;
          }
        }
        if (user == null) {
        }
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    if (authToken == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/ordersadmin'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body)['order'];
          showOrders = true; // Show orders after fetching
        });
      } else {
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Cart Page',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: showOrders ? _buildOrdersList() : _buildCartItemsList(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _checkout,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple, // Set text color to white
            ),
            child: const Text('Checkout'),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(
              cartItems[index]['image'],
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image);
              },
            ),
            title: Text(
              cartItems[index]['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${cartItems[index]['price']} \$'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle,
                  color: Colors.red), // Color for remove icon
              onPressed: () => _removeFromCart(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        if (orders[index]['user_id'] == user?['id']) {
          String formattedDate = orders[index]['date'];
          String categoryName = orders[index]['products'][0]['product_object']
              ['category_object']['name'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    ' $categoryName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Total: ${orders[index]['total']} \$'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Date: $formattedDate'),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red), // Color for delete icon
                        onPressed: () =>
                            _deleteOrder(orders[index]['id'].toString()),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders[index]['products'].length,
                  itemBuilder: (context, productIndex) {
                    var product = orders[index]['products'][productIndex]
                        ['product_object'];
                    return ListTile(
                      leading: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${product['price']} \$'),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _removeFromCart(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', json.encode(cartItems));
  }

  void _checkout() async {
    fetchOrders();
  }

  Future<void> _deleteOrder(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    if (authToken == null) {
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/deleteOrder/$orderId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          orders.removeWhere((order) => order['id'].toString() == orderId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order deleted successfully'),
            backgroundColor: Colors.green, // Color for success message
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete order'),
            backgroundColor: Colors.red, // Color for error message
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting order'),
          backgroundColor: Colors.red, // Color for error message
        ),
      );
    }
  }
}
