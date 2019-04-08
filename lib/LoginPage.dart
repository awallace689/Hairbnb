import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Storage.dart';
import 'User.dart';

class LoginPage extends StatefulWidget {
  final Storage storage;

  LoginPage({Key key, @required this.storage}) : super(key: key);

  Login createState() => Login();
}

class Login extends State<LoginPage>{
  final EmailCont = TextEditingController();
  final PasswordCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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

  Future TryLogin() async
  {
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

  bool IsUser(String email)
  {
    return false;
  }

  Future<bool> SaveLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("EmailLogin", email);
    prefs.setString("PasswordLogin", password);
  }
}