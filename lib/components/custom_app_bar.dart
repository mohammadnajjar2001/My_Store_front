import 'package:flutter/material.dart';

AppBar customAppBar({
  required String title,
  List<Widget>? actions,
  Widget? searchWidget,
}) {
  return AppBar(
    title: searchWidget ?? Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: actions ?? [],
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}
