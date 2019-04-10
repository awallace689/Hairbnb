import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'User.dart';
import 'dart:convert';

///Creates a page for the User to sign up.
///
///This class is a stateful widget, so it can be changed at runtime.
class SignUpPage extends StatefulWidget {
  SignUp createState() => SignUp();
}

///Implementation of the SignUpPage class.
///
///Shows a sign up form for the user to fill out to create an account.
class SignUp extends State<SignUpPage>{
  int _currentStep = 0;
  File _image;
  final EmailCont = TextEditingController();
  final PasswordCont = TextEditingController();
  final FNameCont = TextEditingController();
  final LNameCont = TextEditingController();
  final PhoneCont = TextEditingController();

  ///Builds the UI objects on the screen.
  ///
  ///This function is called anytime something on the screen
  ///affects these UI objects. Returns the UI objects to be displayed.
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Stepper(
        steps: _FormSteps(),
        currentStep: this._currentStep,
        onStepTapped: (step){
            setState((){
                this._currentStep = step;
            });
        },
        onStepCancel: (){
            setState((){
              if(this._currentStep > 0){
                this._currentStep -= 1;
              }
            });
        },
        onStepContinue: (){
          setState(() {
            if(this._currentStep < this._FormSteps().length - 1){
              this._currentStep += 1;
            }
            else{
              CreateNewUser(context);
            }
          });
        },
      )
    );
  }

  ///Creates a list of steps to be used as the sign up form.
  ///
  ///Steps allow for some information to be hidden until the user
  ///is ready to see this information. Each of these steps contain
  ///a different part of the sign up form. Returns the list of steps.
  List<Step> _FormSteps(){
    List<Step> _steps = [
      Step(
        title: Text("Login Info"),
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: EmailCont,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
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
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text("Personal Info"),
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: FNameCont,
              obscureText: false,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "First Name",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(height: 15.0,),
            TextFormField(
              controller: LNameCont,
              obscureText: false,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "LastName",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(height: 15.0,),
            TextFormField(
              controller: PhoneCont,
              obscureText: false,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Phone Number",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text("Profile Picture"),
        content: Column(
          children: <Widget>[
            _image == null ? Text("No image selected.") : Image.file(_image),
            _image == null ? Container() : RaisedButton(
              child: Text("Choose from gallery"),
              onPressed: getImageFromGallery,
            ),
            _image == null ? Container() : RaisedButton(
              child: Text("Choose from camera"),
              onPressed: getImageFromCamera,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
    return _steps;
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
      _image = croppedFile;
    });
  }

  ///Creates a new user from form data.
  ///
  ///Takes all the data from the form inputs and creates a new user.
  ///This will eventually upload the data to a database, but for now,
  ///it shows the information to be uploaded in a dialog box.
  Future CreateNewUser(BuildContext context) async
  {
    final NewUser = new User(EmailCont.text,
                             PasswordCont.text,
                             FNameCont.text,
                             LNameCont.text,
                             PhoneCont.text,
                             _image.toString(),
                             [],
                             false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(jsonEncode(NewUser.toJson())),
        );
      },
    );
  }
}