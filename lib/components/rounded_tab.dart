import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RoundedTab extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double fontSize;
  const RoundedTab({super.key,
  required this.text,
  required this.width,
  required this.height,
  required this.fontSize,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Fixed width
      height: height, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // Offset of the shadow
          ),
        ],
      ),
      child: Center(
        child: AutoSizeText(
          text,
          style: TextStyle(color: Colors.black, fontSize: fontSize),
          maxLines: 1,// Black text color
        ),
      ),
    );
  }
}
