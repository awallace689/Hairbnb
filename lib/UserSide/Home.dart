import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  /// Creates a stateful widget and a stateful element,
  /// and the stateful element will be mounted to the element tree.

  /// Default constructor that takes no parameter.
  HomePage();

  /// Returns a Container widget which holds a network image, and
  /// the image is going to cover the whole screen of the phone.
  /// A Welcome text will be displayed at the bottom left corner of
  /// the background image.
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image:NetworkImage("https://fastly.4sqi.net/img/general/600x600/790765_pGmlPfzRmKiqZv0erX_CnueWVY9koGaZJR0YVThBI4I.jpg"), fit: BoxFit.fill )),
                      child: Stack(children: <Widget>[Positioned(left: 10.0, bottom: 0.0, child: Text('WELCOME', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)))]));
  }
}
