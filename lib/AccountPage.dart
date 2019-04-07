import 'package:flutter/material.dart';
import 'package:project4/LoginPage.dart';
import 'package:project4/SignUpPage.dart';
import 'package:project4/UserPage.dart';
import 'package:project4/AdminPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Storage.dart';
import 'User.dart';
import 'SplashPage.dart';
import 'LoginScreen.dart';


class AccountPage extends StatefulWidget {
  final Storage storage;

  AccountPage({Key key, @required this.storage}) : super(key: key);

  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String Login = "";

  @override
  void initState() {
    GetEmailLogin().then(UpdateLogin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Future.wait([InitialLoad(), GetEmailLogin()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if(snapshot.data[1] == ""){
                return LoginScreen(storage: widget.storage,);
              }
              else{
                if(snapshot.data[0].isAdmin) {
                  return AdminPage();
                }
                else{
                  return UserPage();
                }
              }
            } else {
              return new CircularProgressIndicator();
            }
          }
          else {
            return SplashPage();
          }
        },
      ),
    );
  }

  Future<User> InitialLoad() async {
    await Future.delayed(Duration(seconds: 1));
    return widget.storage.HTTPToUser(
        "http://www.json-generator.com/api/json/get/ceJipFMTkO?indent=2");
  }


  Future<String> GetEmailLogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("EmailLogin") ?? "";
  }

  void UpdateLogin(String loadedLogin)
  {
    setState(() {
      this.Login = loadedLogin;
    });
  }
}