import 'package:flutter/material.dart';
import 'package:my_strore/admin/Product/EditProduct.dart';
import 'package:my_strore/components/CategoryItem.dart';
import 'package:my_strore/components/IconData.dart';
import 'package:my_strore/components/ProductDetailDialog.dart';
import 'package:my_strore/components/ProductItem.dart';
import 'package:my_strore/components/api_services_home.dart';
import 'package:my_strore/components/bottom_navigation_bar.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:my_strore/components/custom_drawer.dart';
import 'package:my_strore/components/shared_preferences_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      final authToken = await getAuthToken();
      final email = await getEmail();
      if (authToken != null && email != null) {
        final fetchedUser = await fetchUser(authToken, email);
        setState(() {
          user = fetchedUser;
        });
        if (user != null) {
          await setRole(user!['role']);
        }
      }
      final fetchedCategories = await fetchCategories();
      setState(() {
        categories = fetchedCategories;
        if (categories.isNotEmpty) {
          selectedCategory = categories[0]['id'].toString();
          _fetchProducts(selectedCategory);
        }
      });
    } catch (e) {
      // Handle exceptions if needed
    }
  }

  Future<void> _fetchProducts(String categoryId) async {
    try {
      final fetchedProducts = await fetchProducts(categoryId);
      setState(() {
        products = fetchedProducts;
        filteredProducts = products;
      });
    } catch (e) {
      // Handle exceptions if needed
    }
  }

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()) ||
              product['description']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: '',
        searchWidget: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: _filterProducts,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _filterProducts('');
              _searchFocusNode.unfocus();
            },
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
                      _fetchProducts(selectedCategory);
                      _searchController.clear(); // Clear search field on category change
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductItem(
                  image: product['image'] ?? '',
                  label: product['name'] ?? 'No Name',
                  price: '${product['price'] ?? '0'} \$',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProductDetailDialog(product: product);
                      },
                    );
                  },
                  onEdit: () {
                    if (user != null && user!['role'] == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProductPage(product: product),
                        ),
                      );
                    }
                  },
                  user: user,
                  productId: product['id'].toString(),
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
              break;
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
          await clearPreferences();
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, '/login',(route)=>false);
        },
      ),
    );
  }
}
