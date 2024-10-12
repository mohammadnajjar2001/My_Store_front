import 'package:flutter/material.dart';
import 'package:my_strore/components/CategoryItem.dart';
import 'package:my_strore/components/IconData.dart';
import 'package:my_strore/components/ProductItem.dart';
import 'package:my_strore/components/SearchDelegate.dart';
import 'package:my_strore/components/api_services_home.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:my_strore/components/custom_drawer.dart';
import 'package:my_strore/components/shared_preferences_service.dart';
import 'package:my_strore/components/bottom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Homepage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.purple,
        scaffoldBackgroundColor:
            Colors.grey[100], // Background color for the scaffold
        appBarTheme: const AppBarTheme(
          color: Colors.red, // Color of the AppBar
          elevation: 2, // Slight shadow for AppBar
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.redAccent, // Color of buttons
          textTheme: ButtonTextTheme.primary,
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  String selectedCategory = '';
  List categories = [];
  List topSellingProducts = [];
  Map<String, dynamic>? user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final authToken = await getAuthToken();
      final email = await getEmail();
      if (authToken != null && email != null) {
        final results = await Future.wait([
          fetchCategories(),
          fetchTopSellingProducts(authToken),
          fetchUsers(authToken),
        ]);

        setState(() {
          categories = results[0];
          topSellingProducts = results[1];
          user = (results[2]).firstWhere(
            (u) => u['email'] == email,
            orElse: () => null,
          );
          if (user != null) {
            setRole(user!['role']);
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text('My Store', style: TextStyle(color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 127, 54, 244),
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      data:
                          categories.map((c) => c['name'].toString()).toList()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: customAppBar(
          title: 'HOME',
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      data:
                          categories.map((c) => c['name'].toString()).toList()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPromotionBanner(),
                const SizedBox(height: 20),
                buildCategoriesSection(),
                const SizedBox(height: 20),
                buildTopSellingSection(),
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
        drawer: CustomDrawer(
          user: user,
          onLogout: () async {
            await clearPreferences();
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
        ),
      );
    }
  }

  Widget buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.purpleAccent
          ], // تدرج من الأرجواني الداكن إلى الأرجواني اللامع
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'A Summer Surprise\nDiscount 80%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryItem(
                icon: getCategoryIcon(categories[index]['name']),
                label: categories[index]['name'],
                onTap: () =>
                    _navigateToCategory(context, categories[index]['name']),
                isSelected: false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTopSellingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Selling',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: topSellingProducts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final product = topSellingProducts[index];
            var image = product['image'] ?? '';
            return ProductItem(
              image: image,
              label: product['name'] ?? 'No Name',
              price: '\$${product['price'] ?? '0'}',
              onTap: () {},
              onEdit: () {},
              productId: '',
            );
          },
        ),
      ],
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    setState(() {
      selectedCategory = category;
    });
    Navigator.of(context).pushNamed("/category", arguments: category);
  }
}
