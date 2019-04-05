import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'User.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SignUpPage extends StatefulWidget {
  SignUp createState() => SignUp();
}

class SignUp extends State<SignUpPage>{
  int _currentStep = 0;
  final EmailCont = TextEditingController();
  final PasswordCont = TextEditingController();
  final FNameCont = TextEditingController();
  final LNameCont = TextEditingController();
  final PhoneCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
          //child: Padding(
            //padding: const EdgeInsets.all(30.0),
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
                    //Create new user and go to whatever page we want.
                    CreateNewUser();
                  }
                });
              },
            )
        //)
    );
  }

  List<Step> _FormSteps(){
    List<Step> _steps = [
      Step(
        title: Text("Login Info"),
        content: Column(
          children: <Widget>[
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
            RaisedButton(
              child: Text("Choose from gallery"),
              onPressed: getImageFromGallery,
            ),
            RaisedButton(
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

  File _image;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    _cropImage(image);
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    _cropImage(image);
  }

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

  Future<void> CreateNewUser() async
  {
    final NewUser = new User(EmailCont.text,
                             PasswordCont.text,
                             FNameCont.text,
                             LNameCont.text,
                             PhoneCont.text,
                             _image.toString(),
                             [],
                             false);
    print(NewUser.toJson());
  }
}