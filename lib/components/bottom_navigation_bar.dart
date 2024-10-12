import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'View section',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.deepPurple, // اللون المحدد
      unselectedItemColor: Colors.deepPurple.shade200, // اللون غير المحدد
      backgroundColor: Colors.white, // خلفية شريط التنقل
      elevation: 8, // تأثير الظل
      onTap: widget.onTap,
    );
  }
}
