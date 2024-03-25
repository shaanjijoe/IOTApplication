import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  String message;
  MyButton({
    super.key,
    required this.onTap,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular (10),
      ), // BoxDecoration child: const Center(
        child:  Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
          ), // TextStyle
          ),
        ), // Text ), // Center
      ),
    ); // Container
  }
}
