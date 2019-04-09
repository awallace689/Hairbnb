import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.greenAccent),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(125),
          child: Image.asset('assets/HairbnbLogo.png'),
        )
      ),
    );
  }
}