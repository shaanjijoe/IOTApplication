import 'package:flutter/material.dart';

class ActiveButton extends StatefulWidget {
  final Function()? onTap;
  final String message;
  final String activeMessage;
  // final bool isActive;
  ActiveButton({
    Key? key,
    required this.onTap,
    required this.message,
    required this.activeMessage,
    // required this.isActive,
  }) : super(key: key);

  @override
  _ActiveButtonState createState() => _ActiveButtonState();
}

class _ActiveButtonState extends State<ActiveButton> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;

    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
        widget.onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 25),
        decoration: BoxDecoration(
          color: isActive ? Colors.lightGreen : Colors.black,
          borderRadius: BorderRadius.circular(30), // Adjust the border radius as needed
        ),
        child: Center(
          child: Text(
            isActive ? widget.activeMessage : widget.message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
