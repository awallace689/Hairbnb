import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:project4/HomePage.dart';
import 'package:project4/AccountPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Main Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new TabBarView(
          children: <Widget>[
            new HomePage(),
            new AccountPage(),
          ],
        controller: tabController,
      ),

      bottomNavigationBar: new Material(
        color: Colors.lightBlue,
        child: new TabBar(
          controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: Icon(Icons.home),
              ),
              new Tab(
                icon: Icon(Icons.account_circle),
              )
            ]

        ),
      ),
    );
  }
}
