import 'package:flutter/material.dart';

class MyAccount_User extends StatefulWidget {

  final username;
  final email;

  MyAccount_User(this.username, this.email);

  @override
  _MyAccount_UserState createState() => _MyAccount_UserState();
}

class _MyAccount_UserState extends State<MyAccount_User> {

  int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[UserAccountsDrawerHeader(accountEmail: Text(widget.email), accountName: Text(widget.username), currentAccountPicture: GestureDetector(child: CircleAvatar(backgroundColor: Colors.white, child: Text("A")))),
    DefaultTabController(length: 2, child: TabBar(tabs: <Widget>[Tab(text:"HISTORY"), Tab(text: "PURCHASE")], indicatorColor: Colors.white, labelColor: Colors.black, labelPadding: null,))]);
  }
}
