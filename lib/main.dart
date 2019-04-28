import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:project4/TopSide/LoadPage.dart';
import 'dart:async';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green[400],
      ),
      home: LoadPage(),
    );
  }
}

