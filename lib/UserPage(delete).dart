import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserBarberPage(delete).dart';
import 'CheckInPage.dart';
import 'Storage.dart';

class UserPage extends StatefulWidget {
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Page"),
        ),
        body: TabBarView(
          children: <Widget>[
            new UserBarberPage(storage: Storage(),),
            new CheckInPage(storage: Storage(),),
            Text("Account Page")
          ],
        ),
        bottomNavigationBar: TabBar(
            labelColor: Colors.black,
            tabs: <Widget>[
              new Tab(
                text: "Barber",
              ),
              new Tab(
                text: "Check In",
              ),
              new Tab(
                text: "Account",
              )
            ]
        ),
      ),
    );
  }
}