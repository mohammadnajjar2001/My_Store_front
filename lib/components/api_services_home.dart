// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

// Fetch categories from API
Future<List<dynamic>> fetchCategories() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/categories'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['data'] as List<dynamic>;
  } else {
    throw Exception('Failed to load categories');
  }
}

// Fetch products by category ID
Future<List<dynamic>> fetchProducts(String categoryId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));
  if (response.statusCode == 200) {
    List products = json.decode(response.body)['data'];
    return products.where((product) => product['category'].toString() == categoryId).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

// Fetch top selling products
Future<List<dynamic>> fetchTopSellingProducts(String authToken) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/ordersadmin'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    List orders = json.decode(response.body)['order'];
    Map<int, Map<String, dynamic>> productMap = {};

    for (var order in orders) {
      for (var product in order['products']) {
        int productId = product['product'];
        var productObject = product['product_object'];
        if (productMap.containsKey(productId)) {
          productMap[productId]!['count'] += product['qty'];
        } else {
          productMap[productId] = {
            'product': productObject,
            'count': product['qty']
          };
        }
      }
    }

    List topProducts = productMap.values.toList();
    topProducts.sort((a, b) => b['count'].compareTo(a['count']));

    return topProducts.take(2).map((e) => e['product']).toList();
  } else {
    throw Exception('Failed to load top selling products');
  }
}

// Fetch users from API
Future<List<dynamic>> fetchUsers(String authToken) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'] as List<dynamic>;
  } else {
    throw Exception('Failed to load users');
  }
}

// Fetch a specific user by email
Future<Map<String, dynamic>?> fetchUser(String authToken, String email) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
  );
  if (response.statusCode == 200) {
    List users = json.decode(response.body)['data'];
    return users.firstWhere((user) => user['email'] == email, orElse: () => null);
  } else {
    throw Exception('Failed to load user');
  }
}
