import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 120, // زيادة العرض لجعل المظهر أكثر توازنًا
        margin: const EdgeInsets.only(
          right: 15, // زيادة التباعد الجانبي
          bottom: 10, // إضافة تباعد أسفل العنصر
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(20), // تغيير نصف القطر لجعل الزوايا أكثر سلاسة
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // تحسين وضوح الظل
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 48, // زيادة حجم الأيقونة
              color: widget.isSelected ? Colors.white : Colors.deepPurple,
            ),
            const SizedBox(height: 12), // زيادة التباعد بين الأيقونة والنص
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16, // زيادة حجم الخط لجعله أكثر وضوحًا
              ),
            ),
          ],
        ),
      ),
    );
  }
}
