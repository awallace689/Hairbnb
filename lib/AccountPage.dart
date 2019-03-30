import 'package:flutter/material.dart';
import 'package:project4/LoginPage.dart';
import 'package:project4/SignUpPage.dart';

class AccountPage extends StatelessWidget {
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
              new LoginPage(),
              new SignUpPage(),
            ],
          )
        )
      ),
    );
  }
}