import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_strore/components/CategoryItem.dart';
import 'package:my_strore/components/IconData.dart';
import 'package:my_strore/components/bottom_navigation_bar.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:my_strore/components/custom_drawer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class dd extends StatefulWidget {
  const dd({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ddState createState() => _ddState();
}

// ignore: camel_case_types
class _ddState extends State<dd> {
  String selectedCategory = '1'; // Default category ID
  int _selectedIndex = 0;
  List categories = [];
  List products = [];
  List filteredProducts = [];
  Map<String, dynamic>? user; // To store user details
  String searchQuery = ''; // To store search query
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    retrieveAuthToken();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> retrieveAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    String? email = prefs.getString('email');

    if (authToken != null && email != null) {
      fetchUser(authToken, email);
    }
  }

  Future<void> fetchUser(String authToken, String email) async {
    try {
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
        for (var u in users) {
          if (u['email'] == email) {
            setState(() {
              user = u;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('role', u['role']);
            break;
          }
        }
      }
    } catch (e) {
    }
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/categories'));
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body)['data'];
        if (categories.isNotEmpty) {
          selectedCategory = categories[0]['id'].toString();
          fetchProducts(selectedCategory);
        }
      });
    }
  }

  Future<void> fetchProducts(String categoryId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = json
            .decode(response.body)['data']
            .where((product) => product['category'].toString() == categoryId)
            .toList();
        filteredProducts = products;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'view section ',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return CategoryItem(
                  icon: getCategoryIcon(category['name']),
                  label: category['name'] ?? 'No Name',
                  isSelected: selectedCategory == category['id'].toString(),
                  onTap: () {
                    setState(() {
                      selectedCategory = category['id'].toString();
                      fetchProducts(selectedCategory);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  imageUrl: product['image'] ?? '',
                  name: product['name'] ?? 'No Name',
                  price: '${product['price'] ?? '0'} \$',
                  time: product['created_at'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
            case 1:
              Navigator.pushNamed(context, '/cart');
              break;
            case 2:
              Navigator.pushNamed(context, '/new');
              break;
            default:
              break;
          }
        },
      ),
      drawer: CustomDrawer(
        user: user,
        onLogout: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String time;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              price,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Added on: $time',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
