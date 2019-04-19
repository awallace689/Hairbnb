import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Storage.dart';
import 'User.dart';
import 'SplashPage.dart';
import 'LoginScreen.dart';
import 'LoginSignUp.dart';
import 'AllenUserPage.dart';
import 'AllenAdminPage.dart';

///Directs the application to the correct page.
class AccountPage extends StatefulWidget {
  final Storage storage;

  AccountPage({Key key, @required this.storage}) : super(key: key);

  AccountPageState createState() => AccountPageState();
}

///Implementation of the AccountPage class.
///
///Loads the correct widget when the application is opened.
class AccountPageState extends State<AccountPage> {
  String Login = "";

  ///Initializes the state of the AccountPage.
  @override
  void initState() {
    getEmailLogin().then(updateLogin);
    super.initState();
  }

  ///Directs the application to the correct page upon opening.
  ///
  /// If there is no user preferences stored, then load the login screen.
  /// If there a user preference stored, then load either the user page,
  /// or the admin page depending on their status. While the data
  /// is being fetched, a loading circle will show.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Future.wait([initialLoad(), getEmailLogin()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if(snapshot.data[1] == ""){
                //return LoginScreen(storage: widget.storage,);
                return LoginSignUp();
              }
              else{
                if(snapshot.data[0].isAdmin) {
                  return AllenAdminPage();
                }
                else{
                  return AllenUserPage();
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

  ///Loads the saved user if one.
  ///
  /// Requests the user from storage if there is one. After a 2 second
  /// delay to show the splash screen.
  Future<User> initialLoad() async {
    await Future.delayed(Duration(seconds: 2));
    return widget.storage.HTTPToUser(
        "http://www.json-generator.com/api/json/get/ceJipFMTkO?indent=2");
  }

  ///Retrieves the email from application preferences.
  Future<String> getEmailLogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("EmailLogin") ?? "";
  }

  ///Updates the Login of this class to [loadedLogin].
  void updateLogin(String loadedLogin)
  {
    setState(() {
      this.Login = loadedLogin;
    });
  }
}
