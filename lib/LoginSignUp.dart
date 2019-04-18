import 'package:flutter/material.dart';
import 'Storage.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'AllenAdminPage.dart';
import 'AllenUserPage.dart';

enum FormMode { LOGIN, SIGNUP};

class LoginSignUp extends StatefulWidget {
  LoginSignUpState createState() => LoginSignUpState();
}

class LoginSignUpState extends State<LoginSignUp> {
  FormMode formMode = FormMode.LOGIN;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: formMode == FormMode.LOGIN ? _BuildLoginPage() : _BuildSignUpPage(),
      routes: {
        '/User': (context) => AllenUserPage(),
        '/Admin': (context) => AllenAdminPage(),
      },
    );
  }

  Widget _BuildLoginPage()
  {
    return Scaffold(
      body: Form(
        child: ListView(
          children: <Widget>[
            _ShowEmailInput(),
            _ShowPasswordInput(),
            _ShowSubmitButton(),
            _ShowSwitchButton()
          ],
        ),
      ),
    );
  }

  Widget _ShowEmailInput()
  {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value,
    );
  }

  Widget _BuildSignUpPage()
  {
    return Scaffold(
      body: Form(
        child: ListView(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}