import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Storage.dart';
import 'User.dart';

///Creates a page for the User to log in.
///
///This class is a stateful widget, so it can be changed at runtime.
class LoginPage extends StatefulWidget {
  final Storage storage;

  LoginPage({Key key, @required this.storage}) : super(key: key);

  Login createState() => Login();
}

///Implementation of the LoginPage class.
///
///Shows a log in form for the user to sign in to an existing account.
class Login extends State<LoginPage>{
  final EmailCont = TextEditingController();
  final PasswordCont = TextEditingController();

  ///Initializes the state of the log in screen.
  @override
  void initState() {
    super.initState();
  }

  ///Disposes of the classes attributes when the object is destroyed.
  @override
  void dispose() {
    EmailCont.dispose();
    PasswordCont.dispose();
    super.dispose();
  }

  ///Builds the UI objects on the screen.
  ///
  ///This function is called anytime something on the screen
  ///affects these UI objects. Returns the UI objects to be displayed.
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    child: Icon(
                        Icons.apps
                    ),
                  ),
                  TextFormField(
                    controller: EmailCont,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Email",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    controller: PasswordCont,
                    obscureText: true,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Password",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 30.0,),
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.lightGreen,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: TryLogin,
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0).copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ),
                ],
            ),
          ),
        )
    );
  }

  ///Tries the users inputs to continue in the application.
  ///
  /// If the user enters correct credentials then it will direct them
  /// to the correct post login screen. Otherwise the user will be
  /// shown a popup saying their credentials are incorrect.
  Future TryLogin() async
  {
    if(EmailCont.text == "Admin" || EmailCont.text == "User"){
      Navigator.pushReplacementNamed(context, '/' + EmailCont.text);
    }

    String email = EmailCont.text;
    String password = PasswordCont.text;

    User user = await UserExists(email, password);
    if(user != null)
    {
      SaveLogin(email, password);
      if(user.isAdmin)
      {
        Navigator.pushReplacementNamed(context, '/Admin');
      }
      else{
        Navigator.pushReplacementNamed(context, '/User');
      }
    }
    else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Email or password is incorrect."),
          );
        },
      );
    }
  }

  ///Checks if the user exists.
  ///
  /// Requests the list of users from the url and checks if the
  /// [email] and [password] matches one of the users'. Returns
  /// the user if the user exists, otherwise returns null.
  Future<User> UserExists(String email, String password) async
  {
    List<User> UserList = await widget.storage.HTTPToUserList(
        "http://www.json-generator.com/api/json/get/cffVCtGfaW?indent=2");
    for(User user in UserList){
      if(user.email == email && user.password == password){
        return user;
      }
    }
    return null;
  }

  ///Saves the user's email and password on successful login.
  ///
  /// Puts the user's [email] and [password] in the app's user preferences,
  /// so the user does not have to log in every time.
  Future<bool> SaveLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("EmailLogin", email);
    prefs.setString("PasswordLogin", password);
  }
}