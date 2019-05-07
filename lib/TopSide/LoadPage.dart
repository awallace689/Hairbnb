import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashPage.dart';
import 'LoginSignUp.dart';
import 'package:project4/UserSide/UserPage.dart';

///Directs the application to the correct page.
class LoadPage extends StatefulWidget {

  LoadPageState createState() => LoadPageState();
}

///Implementation of the AccountPage class.
///
///Loads the correct widget when the application is opened.
class LoadPageState extends State<LoadPage> {
  ///Initializes the state of the AccountPage.
  @override
  void initState() {
    super.initState();
  }

  ///Directs the application to the correct page upon opening.
  ///
  /// If there is no user preferences stored, then load the login screen.
  /// If there is a user preference stored, then load either the user page,
  /// or the admin page depending on their status. While the data
  /// is being fetched, a loading circle will show.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Future.wait([Splash(), getUserID()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              print(snapshot.data[1]);
              //If the user has not logged in before.
              if(snapshot.data[1] == ""){
                return LoginSignUp();
              }
              else{
                return UserPage();
              }
            }
            else {
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


  ///Displayes a splash screen for 2 seconds.
  Future Splash() async {
    await Future.delayed(Duration(seconds: 2));
  }

  ///Retrieves the userid from application preferences.
  Future<String> getUserID() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserID") ?? "";
  }
}
