import 'package:flutter/material.dart';
import 'Storage.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'AllenAdminPage.dart';
import 'AllenUserPage.dart';

///Creates a page for the user to log in.
///
///This class is a stateful widget, so it can be changed at runtime.
class LoginScreen extends StatefulWidget {
  final Storage storage;

  LoginScreen({Key key, @required this.storage}) : super(key: key);

  LoginScreenState createState() => LoginScreenState();
}

///Implementation of the LoginScreen class.
///
///Shows a tabbed menu where the user can choose to log in or sign up.
class LoginScreenState extends State<LoginScreen> {

  ///Initializes the state of the log in screen.
  @override
  void initState() {
    super.initState();
  }

  ///Builds the UI objects on the screen.
  ///
  ///This function is called anytime something on the screen
  ///affects these UI objects. Returns the UI objects to be displayed.
  ///On successful login and or sign up, the user will either be taken
  ///to the user or admin route, which is a separate part of the application.
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