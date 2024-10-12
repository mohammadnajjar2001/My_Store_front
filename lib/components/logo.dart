import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
        ),
        Container(
  alignment: Alignment.center,
  height: 120,
  width: 120,
  margin: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(60), // تعديل نصف القطر ليطابق نصف ارتفاع وعرض ال Container
    color: Colors.grey[600],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(60), // يجب أن يكون نفس نصف القطر هنا
    child: Image.asset(
      "images/logo.jpg",
      height: 120,
      width: 120,
      fit: BoxFit.cover, // هذا يضمن أن الصورة تملأ الحاوية بشكل مناسب
    ),
  ),
)

      ],
    );
  }
}
