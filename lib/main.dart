import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:project4/AccountPage.dart';
import 'dart:async';
import 'dart:io';
import 'Storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountPage(storage: Storage()),
    );
  }
}

