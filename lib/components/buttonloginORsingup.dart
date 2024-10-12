
import 'package:flutter/material.dart';

class ButtonLoginORSingup extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final Color buttonColor;
  final Color textColor;

  const ButtonLoginORSingup({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor =  Colors.deepPurple,
    this.textColor = Colors.white,
  });

  @override
  State<ButtonLoginORSingup> createState() => _ButtonLoginORSingupState();
}

class _ButtonLoginORSingupState extends State<ButtonLoginORSingup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: widget.buttonColor, // لون الخلفية للأزرار
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: widget.textColor, // لون النص
          ),
        ),
      ),
    );
  }
}
