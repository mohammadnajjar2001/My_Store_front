import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Map<String, dynamic>? user;
  final VoidCallback onLogout;

  const CustomDrawer({super.key, this.user, required this.onLogout});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          widget.user != null
              ? UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple, // Change color for a modern look
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  accountName: Text(
                    widget.user!['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    widget.user!['email'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.user!['name'][0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                )
              : const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Account Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                // Show add/edit options based on role
                if (widget.user != null && widget.user!['role'] == 'admin') ...[
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.deepPurple),
                    title: const Text('Add Category'),
                    onTap: () {
                      Navigator.pushNamed(context, '/AddCategory');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.deepPurple),
                    title: const Text('Edit Category'),
                    onTap: () {
                      Navigator.pushNamed(context, '/EditCategory');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_shopping_cart,
                        color: Colors.deepPurple),
                    title: const Text('Add Product'),
                    onTap: () {
                      Navigator.pushNamed(context, '/AddProduct');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.deepPurple),
                    title: const Text('Edit Product'),
                    onTap: () {
                      Navigator.pushNamed(context, '/EditProduct');
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.show_chart, color: Colors.deepPurple),
                    title: const Text('Show Statistics'),
                    onTap: () {
                      Navigator.pushNamed(context, '/Statistics');
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.show_chart, color: Colors.deepPurple),
                    title: const Text('Show all orders'),
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.deepPurple),
                  title: const Text('Orders'),
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout'),
                  onTap: () async {
                    widget.onLogout(); // استدعاء التابع لتسجيل الخروج
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
