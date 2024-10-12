// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductDetailDialog extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailDialog({super.key, required this.product});

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  String _errorMessage = '';
  String _successMessage = '';
  Future<void> _purchaseProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      setState(() {
        _errorMessage = 'User is not logged in';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.redAccent, // تغيير لون خلفية التنبيه
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/addorders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'products': [
          {
            'id': widget.product['id'],
            'qty': 1,
            'price': widget.product['price'],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _successMessage = 'Order has been placed successfully';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_successMessage),
          backgroundColor: Colors.greenAccent, // تغيير لون خلفية التنبيه
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to place the order';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.redAccent, // تغيير لون خلفية التنبيه
        ),
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _showConfirmPurchaseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content:
              const Text('Are you sure you want to purchase this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _purchaseProduct();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product['name']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: Image.network(
              widget.product['image'],
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text('Price: ${widget.product['price']} \$'),
          const SizedBox(height: 8),
          Text('Description: ${widget.product['description']}'),
        ],
      ),
      actions: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _showConfirmPurchaseDialog();
              },
              child: const Text(
                'Buy',
                style: TextStyle(color: Colors.blueAccent), // تغيير لون النص
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey), // تغيير لون النص
              ),
            ),
          ],
        ),
      ],
    );
  }
}
