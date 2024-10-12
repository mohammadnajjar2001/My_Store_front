import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_strore/components/bottom_navigation_bar.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Editcategory extends StatefulWidget {
  const Editcategory({super.key});

  @override
  State<Editcategory> createState() => _EditcategoryState();
}

class _EditcategoryState extends State<Editcategory> {
  int _currentIndex = 0;
  String selectedCategoryId = ''; // لتخزين معرف الصنف المحدد
  List categories = [];
  Map<String, dynamic>? user; // لتخزين تفاصيل المستخدم
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true; // لتخزين حالة التحميل
  String authToken = ''; // لتخزين رمز التوثيق

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _loadAuthToken();
    
  }

  Future<void> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('authToken') ?? '';
    });
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        // Handle failure
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _updateCategory() async {
    if (selectedCategoryId.isEmpty) {
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/editcategory/$selectedCategoryId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'desc': _descController.text,
        }),
      );

      if (response.statusCode == 200) {
        _nameController.clear();
        _descController.clear();
        fetchCategories(); // إعادة تحميل الأصناف لتحديث الواجهة
        _showSnackBar('Category updated successfully', Colors.green);
      } else {
        _showSnackBar('Failed to update category', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error updating category', Colors.red);
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/deletecategory/$categoryId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        fetchCategories(); // إعادة تحميل الأصناف لتحديث الواجهة
        _showSnackBar('Category deleted successfully', Colors.green);
      } else {
        _showSnackBar('Failed to delete category', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error deleting category', Colors.red);
    }
  }

  Future<void> _confirmDeleteCategory(String categoryId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(categoryId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(
        title: 'Edit Category',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 174, 157, 226),
                            Colors.blueAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Edit Category',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryItem(
                            icon: getCategoryIcon(categories[index]['name']),
                            label: categories[index]['name'],
                            id: categories[index]['id']
                                .toString(), // تمرير المعرف
                            onTap: () => _navigateToCategory(
                                context, categories[index]['id'].toString()),
                            onDelete: () => _confirmDeleteCategory(
                                categories[index]['id'].toString()),
                            isSelected: categories[index]['id'].toString() ==
                                selectedCategoryId,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Category Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 200, // اضبط العرض حسب الحاجة
                        child: ElevatedButton(
                          onPressed: _updateCategory,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple, // لون الخلفية
                            padding: const EdgeInsets.symmetric(
                                vertical: 16), // تحديد الحشوة
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // تحديد زوايا الزر
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ), // تحديد حجم الخط ووزنه
                          ),
                          child: const Text('Update Category'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
    );
  }

  void _navigateToCategory(BuildContext context, String categoryId) {
    setState(() {
      selectedCategoryId = categoryId; // تخزين المعرف
    });
  }

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'freezers':
        return Icons.ac_unit;
      case 'kitchen appliances':
        return Icons.kitchen;
      case 'electric appliances':
        return Icons.fireplace;
      case 'heating':
        return Icons.ac_unit;
      case 'washing machines':
        return Icons.local_laundry_service;
      case 'laptop':
        return Icons.laptop;
      case 'camera':
        return Icons.camera_alt;
      case 'mobile':
        return Icons.phone_android;
      case 'shoes':
        return Icons.shower_sharp;
      case 'dress':
        return Icons.wallet_giftcard;
      case 'tablet':
        return Icons.tablet;
      case 'accessories':
        return Icons.headset;
      default:
        return Icons.category;
    }
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String id; // معرف الصنف
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isSelected; // لتحديد ما إذا كان الصنف محدداً

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.id,
    required this.onTap,
    required this.onDelete,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.2) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blueAccent : Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
