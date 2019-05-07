import 'package:flutter/material.dart';

///Class creates a splash page with the app logo.
class SplashPage extends StatelessWidget {

  ///Creates the splash page with the logo png
  ///centered on the screen.
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