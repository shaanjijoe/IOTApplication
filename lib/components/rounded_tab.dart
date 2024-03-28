import 'package:flutter/material.dart';

class RoundedTab extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  const RoundedTab({super.key,
  required this.text,
  required this.width,
  required this.height});

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
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 20), // Black text color
        ),
      ),
    );
  }
}
