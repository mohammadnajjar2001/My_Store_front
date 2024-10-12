import 'package:flutter/material.dart';

class Desc extends StatefulWidget {
  final String heder;
  final String desc;
  const Desc({super.key, required this.heder, required this.desc});

  @override
  State<Desc> createState() => _DescState();
}

class _DescState extends State<Desc> {
  @override
  Widget build(BuildContext context) {
    return Column( 
      children: [ 
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.heder,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.desc,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              )
      ],
    );
  }
}