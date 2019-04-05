import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  String email = "before";

  @override
  void initState()
  {
    GetEmail().then(UpdateEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
      ),
      body: Text(email),
    );
  }

  Future<String> GetEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("EmailLogin");
  }

  void UpdateEmail(String loadedEmail)
  {
    setState(() {
      this.email = loadedEmail;
    });
  }
}