import 'package:flutter/material.dart';
import 'package:project4/LoginPage.dart';
import 'package:project4/SignUpPage.dart';
import 'package:project4/UserPage.dart';
import 'package:project4/AdminPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Storage.dart';
import 'User.dart';


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
        future: InitialLoad(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              print(snapshot.data);
              return AdminPage();
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
//    if(Login == "")
//    {
//      return LoginScreen();
//    }
//    else{
//      //User loadedUser = widget.storage.HTTPToUser("http://www.json-generator.com/api/json/get/ceJipFMTkO?indent=2");
//      loadedUser.printUser();
//      if(loadedUser.isAdmin){
//        return AdminPage();
//      }
//      else {
//        return UserPage();
//      }
//    }
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

  Widget LoginScreen()
  {
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
      routes: {
        '/User': (context) => UserPage(),
        '/Admin': (context) => AdminPage(),
      },
    );
  }
}