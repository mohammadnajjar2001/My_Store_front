import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_strore/components/custom_app_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController; // جديد
  late TextEditingController _imageController; // جديد

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _descriptionController = TextEditingController(text: widget.product['description']);
    _categoryController = TextEditingController(text: widget.product['category'].toString()); // جديد
    _imageController = TextEditingController(text: widget.product['image']); // جديد
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose(); // جديد
    _imageController.dispose(); // جديد
    super.dispose();
  }

  Future<void> _updateProduct() async {
    final authToken = await _getAuthToken(); // استبدل هذه الدالة بآلية جلب توكن المصادقة الخاصة بك

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/updateproduct/${widget.product['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'category': int.parse(_categoryController.text), // جديد
        'image': _imageController.text, // جديد
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // العودة إلى الصفحة السابقة وإرسال إشارة بالنجاح
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update the product'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: customAppBar(
        title: 'Edit Product',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _updateProduct();
                  }
                },
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
