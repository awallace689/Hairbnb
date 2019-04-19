import 'package:flutter/material.dart';
import 'Storage.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'AllenAdminPage.dart';
import 'AllenUserPage.dart';
import 'package:intl/intl.dart';
import 'User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FormMode { LOGIN, SIGNUP}

class LoginSignUp extends StatefulWidget {
  LoginSignUpState createState() => LoginSignUpState();
}

class LoginSignUpState extends State<LoginSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  FormMode _formMode = FormMode.LOGIN;
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  bool _isLoading = false;

  String _email = "";
  String _password = "";
  String _fName = "";
  String _lName = "";
  String _phone = "";
  String _month = "";
  String _day = "";
  String _year = "";
  String _DOB = "";

  TextEditingController _DOBControl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blueAccent
        ),
      home: _formMode == FormMode.LOGIN ? _BuildLoginPage(context) : _BuildSignUpPage(),
      routes: {
        '/User': (context) => AllenUserPage(),
        '/Admin': (context) => AllenAdminPage(),
      },
    );
  }

  Widget _BuildLoginPage(BuildContext context)
  {
    double left = 16.0;
    double top = 0;
    double right = 16.0;
    double bottom = 0;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container( 
        decoration: BoxDecoration(
          // color: Colors.green[400],
        ),
        margin: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 32, 0, 32),
              child: Image.asset(
                'assets/HairbnbLogo.png',
                width: 225,
                height: 225,
              ),
            ),
            Card( 
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.elliptical(3,3)),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _ShowEmailInput(),
                      _ShowPasswordInput(),
                      _ShowSubmitButton(),
                      _ShowSwitchButton(),
                      _ShowErrorMessage(),
                      _ShowLoading()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ShowLoading()
  {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Container(height: 0.0, width: 0.0,);
    }
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
          )
      ),
      validator: (value) => _isValidEmail(value) ? null : "Please enter a valid email.",
      onSaved: (value) => _email = value,
    );
  }

  bool _isValidEmail(String input)
  {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  Widget _ShowPasswordInput()
  {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      obscureText: true,
      decoration: new InputDecoration(
          hintText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          )
      ),
      validator: (value) => _isValidPassword(value) ? null : "Please enter a valid password.",
      onSaved: (value) => _password = value,
    );
  }

  bool _isValidPassword(String input)
  {
    final RegExp regex = new RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{4,8}$");
    return regex.hasMatch(input);
  }

  Widget _ShowSubmitButton()
  {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: MaterialButton(
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.blueAccent,
        child: _formMode == FormMode.LOGIN
            ? new Text('Login',
            style: new TextStyle(fontSize: 20.0, color: Colors.white))
            : new Text('Create account',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: _ValidateAndSubmit,
      )
    );
  }

  Widget _ShowSwitchButton()
  {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
          style:
          new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _ChangeFormToSignUp
          : _ChangeFormToLogin,
    );
  }

  void _ChangeFormToSignUp()
  {
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _ChangeFormToLogin()
  {
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  Widget _BuildSignUpPage()
  {
    // return Scaffold(
    //   body: Form(
    //     key: _formKey,
    //     child: ListView(
    //       children: <Widget>[
    //         _buildRow(_ShowEmailInput()),
    //         _buildRow(_ShowPasswordInput()),
    //         _buildRow(_ShowNameInput()),
    //         _buildRow(_ShowPhoneInput()),
    //         _buildRow(_ShowBirthdayInput()),
    //         //_ShowImageInput(),
    //         _buildRow(_ShowSubmitButton()),
    //         _buildRow(_ShowSwitchButton()),
    //         _buildRow(_ShowErrorMessage()),
    //       ],
    //     ),
    //   ),
    // );
    double left = 16.0;
    double top = 16.0;
    double right = 16.0;
    double bottom = 0;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container( 
        decoration: BoxDecoration(
          // color: Colors.green[400],
        ),
        margin: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 32, 0, 32),
              child: Image.asset(
                'assets/HairbnbLogo.png',
                width: 225,
                height: 225,
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _ShowNameInput(),
                      _ShowEmailInput(),
                      _ShowPasswordInput(),
                      _ShowPhoneInput(),
                      _ShowBirthdayInput(),
                      //_ShowImageInput(),
                      _ShowSubmitButton(),
                      _ShowSwitchButton(),
                      _ShowErrorMessage(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ShowNameInput()
  {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.perm_identity,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              // Text("First Name"),
              TextFormField(
                maxLines: 1,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'First'
                ),
                validator: (value) => value.length > 0 ? null : "Please enter a first name.",
                onSaved: (value) => _fName = value,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              // Text("Last Name"),
              TextFormField(
                maxLines: 1,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Last'
                ),
                validator: (value) => value.length > 0 ? null : "Please enter a last name.",
                onSaved: (value) => _lName = value,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _ShowPhoneInput()
  {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
          hintText: 'Phone Number',
          icon: new Icon(
            Icons.phone,
            color: Colors.grey,
          )
      ),
      validator: (value) => _isValidPhone(value) ? null : "Please enter a valid phone number.",
      onSaved: (value) => _phone = value,
    );
  }

  bool _isValidPhone(String input)
  {
    final RegExp regex = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    return regex.hasMatch(input);
  }

  Widget _ShowBirthdayInput()
  {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                autofocus: false,
                maxLengthEnforced: true,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "MM",
                  counterText: ""
                ),
                onSaved: (value) => _month = value,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                autofocus: false,
                maxLengthEnforced: true,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "DD",
                    counterText: ""
                ),
                onSaved: (value) => _day = value,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                autofocus: false,
                maxLengthEnforced: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "YYYY",
                    counterText: ""
                ),
                onSaved: (value) => _year = value,
              )
            ],
          ),
        ),
      ],
    );
  }

  bool _isValidDOB(String dob)
  {
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime convertToDate(String input) {
    try
    {
      var d = new DateFormat.yMd().parse(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Widget _ShowImageInput()
  {
    ///Need to add image inputs.
  }

  _ValidateAndSubmit() async
  {
    setState(() {
      _errorMessage = "";
      //_isLoading = true;
    });
    if(_formMode == FormMode.SIGNUP){
      if(_ValidateAndSave()){
        Map<String, String> name = {
          'first' : _fName,
          'last' : _lName
        };
        FBUser newUser = FBUser(_email, _password, name, _phone, _DOB, null, null, null);
        print(newUser.toJson());

        _CreateUser(newUser);
      }
    }
    else{
      final form = _formKey.currentState;
      form.save();
      _Login();
    }
  }

  bool _ValidateAndSave()
  {
    final form = _formKey.currentState;
    form.validate();
    form.save();
    _DOB = _month + "/" + _day + "/" + _year;

    if(_formMode == FormMode.SIGNUP){
      if(_month == null || _day == null || _year == null){
        setState(() {
          _errorMessage = "Please enter a valid date of birth.";
        });
        return false;
      }
      else{
        if(!_isValidDOB(_DOB)){
          setState(() {
            _errorMessage = "Please enter a valid date of birth.";
          });
          return false;
        }
      }
    }

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  Widget _ShowErrorMessage()
  {
    if(_errorMessage != null){
      if(_errorMessage.length > 0) {
        return Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      }
      else{
        return Container(
          height: 0.0,
        );
      }
    }
    else{
      return Container(
        height: 0.0,
      );
    }
  }

  _CreateUser(FBUser newUser) async
  {
    try{
      _auth.createUserWithEmailAndPassword(email: newUser.email, password: newUser.password);
      var UserID = (await _auth.currentUser()).uid;
      newUser.userid = UserID;
      Firestore.instance.collection("users").document(UserID).setData(newUser.toJson());
      ///Need to save UserID to app preferences.
      ///Need to go to User Page.
    }
    catch(e){
      setState(() {
        _errorMessage = "Email is already in use.";
      });
    }
  }

  _Login() async
  {
    String UserID = "";
    try
    {
      UserID = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).uid;
      ///Need to go to User page if login credentials are correct.
      ///otherwise display error message.
      print(UserID);
    }
    catch (error)
    {
      setState(() {
        _errorMessage = error.details;
      });
    }
  }
}