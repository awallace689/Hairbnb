import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  Login createState() => Login();
}

class Login extends State<LoginPage>{
  final EmailCont = TextEditingController();
  final PasswordCont = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    EmailCont.dispose();
    PasswordCont.dispose();
    super.dispose();
  }

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

  Future TryLogin()
  {///Need to change this to check against list of users.
    String email = EmailCont.text;
    String password = PasswordCont.text;

    if(UserExists(email, password))
    {
      SaveLogin(email);
      if(IsUser(email))
      {
        Navigator.pushReplacementNamed(context, '/User');
      }
      else{
        Navigator.pushReplacementNamed(context, '/Admin');
      }
    }
    else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Email and password do not match."),
          );
        },
      );
    }
  }

  bool UserExists(String email, String password)
  {
    return true;
  }

  bool IsUser(String email)
  {
    return false;
  }

  Future<bool> SaveLogin(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("EmailLogin", email);
  }
}