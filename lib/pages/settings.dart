import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body:  SafeArea( // avoiding notch area
        child: Center( // centering all
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: isTablet ? 50: 25,), //spacing on top

                //logo
                Icon(
                  Icons.lock,
                  size: isTablet ? 100: 50,
                ),





              ],
            ),
          ),
        ),
      ),
    );
  }
}
