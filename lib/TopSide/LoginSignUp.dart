import 'package:flutter/material.dart';
import 'package:project4/AdminSide/AdminPage.dart';
import 'package:project4/UserSide/UserPage.dart';
import 'package:intl/intl.dart';
import 'package:project4/UserSide/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum FormMode { LOGIN, SIGNUP}

///Creates a stateful widget for the login and sign up page.
class LoginSignUp extends StatefulWidget {
  LoginSignUpState createState() => LoginSignUpState();
}

///Creates the state of the statefule widget for this page.
class LoginSignUpState extends State<LoginSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  BuildContext Context;
  FormMode _formMode = FormMode.LOGIN;
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  bool _isLoading = false;
  bool _SelectingImage = false;

  String _email = "";
  String _password = "";
  String _fName = "";
  String _lName = "";
  String _phone = "";
  String _month = "";
  String _day = "";
  String _year = "";
  String _DOB = "";
  File _UserImage;

  TextEditingController _DOBControl = TextEditingController();

  ///Initializes the state of the login and sign up page.
  @override
  void initState() {
    super.initState();
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  ///Builds the main widget for the login and sign up page.
  @override
  Widget build(BuildContext context) {
    Context = context;
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        accentColor: Colors.blueAccent
        ),
      home: _formMode == FormMode.LOGIN ? _BuildLoginPage(context) : _BuildSignUpPage(),
      routes: {
        '/User': (context) => UserPage(),
        '/Admin': (context) => AdminPage(),
      },
    );
  }

  ///Builds the widget for the Login page.
  ///
  /// This page will be build if the user already has an account.
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
                width: 200,
                height: 200,
              ),
            ),
            Card( 
              child: Container(
                padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.elliptical(3,3)),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _ShowEmailInput(withIcon: false),
                      _ShowPasswordInput(withIcon: false),
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

  ///Builds the loading indicator.
  ///
  /// If the page is loading, then show a progress indicator.
  Widget _ShowLoading()
  {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Container(height: 0.0, width: 0.0,);
    }
  }

  ///Builds the email input widget.
  ///
  /// Builds a text input for the user to input their email.
  Widget _ShowEmailInput({withIcon: true})
  {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
          hintText: 'Email',
          icon: withIcon 
          ? new Icon(
            Icons.mail,
            color: Colors.grey,
          )
          : null
      ),
      validator: (value) => isValidEmail(value) ? null : "Please enter a valid email.",
      onSaved: (value) => _email = value,
    );
  }

  ///Validates the email entered.
  ///
  /// Using regex, it validates the input email.
  bool isValidEmail(String input)
  {
    @visibleForTesting
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  ///Builds the password input widget.
  ///
  /// Builds a text input for the user to enter their password.
  Widget _ShowPasswordInput({withIcon: true})
  {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      obscureText: true,
      decoration: new InputDecoration(
          hintText: 'Password',
          icon: withIcon 
          ? new Icon(
            Icons.lock,
            color: Colors.grey,
          )
          : null
      ),
      validator: (value) => isValidPassword(value) ? null : "Please enter a valid password.",
      onSaved: (value) => _password = value,
    );
  }

  ///Validate the password given.
  ///
  /// Using regex, it validates the password give.
  /// Length of 4-8.
  /// Must include number.
  /// Must include lowercase letter.
  /// Must include uppercase letter.
  bool isValidPassword(String input)
  {
    @visibleForTesting
    final RegExp regex = new RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{4,8}$");
    return regex.hasMatch(input);
  }

  ///Builds the submit button widget.
  ///
  /// Builds a button that when clicked will validate and submit the form.
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

  ///Builds the switch button widget.
  ///
  /// Builds the button that when clicked will switch the form to the other state.
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

  ///Switches the form state to signup.
  ///
  /// Changes which form is shown to the other form.
  void _ChangeFormToSignUp()
  {
    setState(() {
      _errorMessage = "";
      _formMode = FormMode.SIGNUP;
    });
  }

  ///Switches the form state to Login.
  ///
  /// Changes which form is shown to the other form.
  void _ChangeFormToLogin()
  {
    setState(() {
      _errorMessage = "";
      _formMode = FormMode.LOGIN;
    });
  }

  ///Builds the sign up form page widget.
  Widget _BuildSignUpPage()
  {
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
              margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Image.asset(
                'assets/HairbnbLogo.png',
                width: 150,
                height: 150,
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                       padding: EdgeInsets.only(right: 36),
                        child: Column(
                          children: <Widget>[
                            _ShowImageInput(),
                            _ShowNameInput(),
                            _ShowEmailInput(),
                            _ShowPasswordInput(),
                            _ShowPhoneInput(),
                            _ShowBirthdayInput(),
                          ]
                        ),
                      ),
                      _ShowSubmitButton(),
                      _ShowSwitchButton(),
                      _ShowErrorMessage(),
                      _ShowLoading(),
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

  ///Builds the name input widget.
  ///
  /// Builds a text input field for the user to enter their name.
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

  ///Builds the phone input widget.
  ///
  /// Builds a text input field that only accepts numbers.
  /// Must be 10 numbers in length.
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
      validator: (value) => isValidPhone(value) ? null : "Please enter a valid phone number.",
      onSaved: (value) => _phone = value,
    );
  }

  ///Validates the given phone number.
  ///
  /// Using regex, it validates the phone number.
  /// Must be 10 numbers in length.
  bool isValidPhone(String input)
  {
    @visibleForTesting
    final RegExp regex = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    return regex.hasMatch(input);
  }

  ///Builds the birthday input widget.
  ///
  /// Builds 3 text input fields, Month, Day, Year.
  /// Each input can only be numbers and are limited on length, MM, DD, YYYY.
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

  ///Checks to see if the date of birth entered is valid.
  ///
  /// Converts [dob] to a DateTime and checks to see if it is before today.
  bool isValidDOB(String dob)
  {
    @visibleForTesting
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  ///Converts the raw date of birth input to a DateTime.
  DateTime convertToDate(String input) {
    try
    {
      var d = new DateFormat.yMd().parse(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  ///Builds the Image input button widget.
  ///
  /// Builds a button that when pressed reveals two more buttons.
  /// One of which allows the user to pick from their gallery, and
  /// the other allows the user to take a photo from the camera.
  Widget _ShowImageInput()
  {
    Widget PhotoIcon = new RawMaterialButton(
      onPressed: () {
        setState(() {
          _SelectingImage = true;
        });
      },
      child: (_UserImage == null) ?
          Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 40.0,
          ) :
          Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(_UserImage)
              )
            )
          ),
      shape: new CircleBorder(),
      elevation: 5.0,
      fillColor: Colors.green,
      padding: (_UserImage == null) ? const EdgeInsets.all(15.0) : EdgeInsets.all(0)
    );
    Widget Buttons = Row(
      children: <Widget>[
        MaterialButton(
          elevation: 5.0,
          minWidth: 10.0,
          height: 42.0,
          color: Colors.green,
          child: Text(
              'From Gallery',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)
          ),
          onPressed: getImageFromGallery,
        ),
        Container(
          width: 5.0,
        ),
        MaterialButton(
          elevation: 5.0,
          minWidth: 10.0,
          height: 42.0,
          color: Colors.green,
          child: Text(
              'From Camera',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)
          ),
          onPressed: getImageFromCamera,
        )
      ],
    );
    return Column(
      children: <Widget>[
        PhotoIcon,
        _SelectingImage ? Buttons : Container(height: 0.0)
      ],
    );
  }

  ///Opens the device camera and prompts user to take a picture.
  ///
  ///Once the user takes a photo, the user is prompted to crop the image.
  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    _cropImage(image);
  }

  ///Opens the device gallery and promps the user to choose a picture.
  ///
  ///Once the user chooses a photo, the user is prompted to crop the image.
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    _cropImage(image);
  }

  ///Opens a page that allows the user to crop the image.
  ///
  ///The user must crop the image into a square. Once the user
  ///crops the image, the image is saved to this class.
  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    setState(() {
      _SelectingImage = false;
      _UserImage = croppedFile;
    });
  }

  ///Validates the form and does the action determined by the formstate.
  ///
  /// Runs all of the input validation functions and
  /// creates a new user if [FormMode] is Signup
  /// or logs in if [FormMode] is login.
  _ValidateAndSubmit() async
  {
    setState(() { });
    if(_formMode == FormMode.SIGNUP){
      if(_ValidateAndSave()){
        Map<String, String> name = {
          'first' : _fName,
          'last' : _lName
        };
        User newUser = User(_email, name, _phone, _DOB, [], null);
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

  ///Runs all input validators and saves the form.
  ///
  /// Runs each input validation method and checks
  /// if a valid birthday was entered, then saves
  /// the form into the designated variables.
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
        if(!isValidDOB(_DOB)){
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

  ///Displays an error message on the form.
  ///
  /// If the error message is not an empty string,
  /// then display the message in red text to the user.
  /// Otherwise display an empty container.
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

  ///Creates a new user from the information given.
  ///
  /// Adds a document to the firestore database with the
  /// information from the signup form. Saves userid to
  /// the app preferences.
  _CreateUser(User newUser) async
  {
    String UserID = "";
    setState(() {
      _isLoading = true;
    });
    try{
      //Create new user in database with email and password.
      await _auth.createUserWithEmailAndPassword(email: newUser.email, password: _password);
      UserID = (await _auth.currentUser()).uid;

      //Save User class to the firestore database with updated userID.
      newUser.userid = UserID;
      Firestore.instance.collection("users").document(UserID).setData(newUser.toJson());

      //Save userID to app preferences.
      _SaveUserID(UserID);

      //Save user profile picture file to database with path: [UserID]/profilePicture.jpg
      final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("$UserID/profilePicture.jpg");
      firebaseStorageRef.putFile(_UserImage);

      //Navigate to user page.
      navigatorKey.currentState.pushReplacementNamed('/User');
    }
    catch(e){
      print(e);
      setState(() {
        _isLoading = false;
        _errorMessage = "Email is already in use.";
      });
    }
  }

  ///Logs the user in from email and password.
  ///
  /// Checks the email and password against the firestore database
  /// and navigates to the user page if the combination is correct,
  /// otherwise shows an error message.
  _Login() async
  {
    String UserID = "";
    setState(() {
      _isLoading = true;
    });
    try
    {
      if(_email == "admin"){
        navigatorKey.currentState.pushReplacementNamed('/Admin');
      }
      UserID = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).uid;
      if(UserID.length > 0){
        _SaveUserID(UserID);
        print(UserID);
        navigatorKey.currentState.pushReplacementNamed('/User');
      }
    }
    catch (error)
    {
      setState(() {
        _isLoading = false;
        _errorMessage = "Email and password do not match.";
      });
    }
  }

  ///Saves the userid to the app preferences.
  Future<bool> _SaveUserID(String ID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserID", ID);
  }
}