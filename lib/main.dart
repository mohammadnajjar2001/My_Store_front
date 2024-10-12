import 'package:flutter/material.dart';
import 'package:my_strore/admin/Product/AddProduct.dart';
import 'package:my_strore/admin/Product/EditProduct.dart';
import 'package:my_strore/admin/Statistics.dart';
import 'package:my_strore/admin/category/AddCategory.dart';
import 'package:my_strore/admin/category/EditCategory.dart';
import 'package:my_strore/admin/orders.dart';
import 'package:my_strore/auth/login.dart';
import 'package:my_strore/auth/singup.dart';
import 'package:my_strore/cart.dart';
import 'package:my_strore/components/profile.dart';
import 'package:my_strore/homepage.dart';
import 'package:my_strore/category.dart';
import 'package:my_strore/new.dart';
import 'package:my_strore/wellcom/onbording.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // تم تصحيح البناء الأساسي للفئة MyApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onbording', // تم تعديل المسار الافتراضي إلى '/login'
      routes: {
        '/signup': (context) =>
            const SignUp(), // تم تعديل الاسم إلى SignUp() وتصحيح المسار إلى '/signup'
        '/login': (context) => const Login(),
        '/home': (context) => const Homepage(),
        '/category': (context) => const CategoryPage(),
        '/cart': (context) => const CartPage(),
        '/AddCategory': (context) => const Addcategory(),
        '/EditCategory': (context) => const Editcategory(),
        '/AddProduct': (context) => const AddProduct(),
        '/EditProduct': (context) => const EditProductPage(
              product: {},
            ),
        '/Statistics': (context) => const Statistics(),
        '/new': (context) => const dd(),
        '/profile': (context) => const Profile(),
        '/orders': (context) => const Orders(),
        '/onbording': (context) => const Onboarding(),
      },
      onUnknownRoute: (settings) {
        // إضافة معالج للمسارات غير المعروفة
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: const Center(
              child: Text('Route not found!'),
            ),
          ),
        );
      },
    );
  }
}
