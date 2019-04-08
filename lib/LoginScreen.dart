import 'package:flutter/material.dart';
import 'Storage.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'UserPage.dart';
import 'AdminPage.dart';
import 'AllenAdminPage.dart';
import 'AllenUserPage.dart';

class LoginScreen extends StatefulWidget {
  final Storage storage;

  LoginScreen({Key key, @required this.storage}) : super(key: key);

  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: TabBar(
                    labelColor: Colors.white,
                    tabs: <Widget>[
                      new Tab(
                        text: "Log In",
                      ),
                      new Tab(
                        text: "Sign Up",
                      )
                    ]
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  new LoginPage(storage: widget.storage,),
                  new SignUpPage(),
                ],
              )
          )
      ),
      routes: {
        '/User': (context) => AllenUserPage(),
        '/Admin': (context) => AllenAdminPage(),
      },
    );
  }
}