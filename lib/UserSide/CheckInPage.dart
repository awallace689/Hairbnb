import 'package:flutter/material.dart';
import 'CheckIn.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';


///Creates a page for the user to check in.
class CheckInPage extends StatefulWidget {

  CheckInPageState createState() => CheckInPageState();
}

///Implementation of the CheckInPage class.
///
///Shows a button to be clicked to checkin and fill out a form.
class CheckInPageState extends State<CheckInPage> {
  bool CheckingIn = false;
  bool CheckedIn = false;
  bool isClicked = false;
  File user_image;
  DateTime selected_date;
  TimeOfDay selected_time;
  DateTime Now = DateTime.now();
  String description;
  List<String> _date = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  List<String> _time = ['9:15 am', '9:30 am', '9:45 am', '10:00 am', '10:15 am', '10:30 am', '10:45 am',
                        '11:00 am', '11:15 am', '11:30 am', '11:45 am', '12:00 pm', '12:15 pm', '12:30 pm'];
  final DescriptCont = TextEditingController();

  Future<void> addData(appointment) async{

    DocumentReference ref = Firestore.instance.collection("Appointment").document();
    print(ref.documentID);

    //Add appointment document to appointment collection with a new documentID
    Firestore.instance.collection("Appointment").document(ref.documentID).setData(appointment);

    //Add the image to the userid folder with the name of the documentID.
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("${appointment["UserID"]}/${ref.documentID}.jpg");
    if(user_image != null) firebaseStorageRef.putFile(user_image);

    //Add the appointment to the users appointments.
    final userRef = await Firestore.instance.collection("users").document(appointment["UserID"]).get();
    print(userRef.data['pastVisits'].toString());
    List<dynamic> pastVisits = List<dynamic>();
    pastVisits.addAll(userRef.data['pastVisits']);
    pastVisits.add(
        {
          "AppointmentID" : ref.documentID,
          "Notes" : appointment["Note"],
          "Time" : {
              "Date" : appointment["Date"],
              "Time" : appointment["Time"]
            }
        }
      );
    dynamic UserData = userRef.data;
    userRef.data['pastVisits'] = pastVisits;

    Firestore.instance.collection("users").document(appointment["UserID"]).setData(UserData);
  }

   imgCapture() async
  {
     File img = await ImagePicker.pickImage(source: ImageSource.gallery);
     _cropImage(img);
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
      user_image = croppedFile;
    });
  }

  Widget CheckInForm(BuildContext context){
    return Scaffold(backgroundColor: Theme.of(context).primaryColor,
        body:Center(
            child: SizedBox(width: 200.0, height: 200.0,
                child: FloatingActionButton(backgroundColor: Colors.white,
                    child:Text("Check in"),
                    foregroundColor: Colors.black ,
                    onPressed: () => {setState(() {
                       isClicked=true;
                    })})
            ))
    );
  }

  Widget allentest(BuildContext context){
    return ListView(children: <Widget>[ SizedBox(height:10.0),
      RawMaterialButton(
        onPressed: imgCapture,
        child: (user_image == null) ?
          Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 80.0,
          ) :
          Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(user_image)
              )
            )
          ),
        shape: new CircleBorder(),
        elevation: 5.0,
        fillColor: Colors.green,
        padding: (user_image == null) ? const EdgeInsets.all(15.0) : EdgeInsets.all(0)
      ),
                  SizedBox(height: 20.0),
                  Row(children: <Widget>[Text("Special requests:", style: TextStyle(fontWeight: FontWeight.bold),
                                                textScaleFactor: 1.4,)],),
                  SingleChildScrollView (child:
                  TextField(controller: DescriptCont, onChanged: (note){description=note;} , decoration: InputDecoration(
                  hintText: "Description of your haircut."),  maxLines: 4)),
                  Row(children: <Widget>[Text("Schedule a time:", style: TextStyle(fontWeight: FontWeight.bold),
                                         textScaleFactor: 1.4,)],),
//                  DropdownButton(hint: Text('Select a date'), value: selected_date,
//                                 items: _date.map((date) {
//                                      return DropdownMenuItem(child: Text(date), value: date);}).toList(),
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     selected_date = newValue;
//                                   });},
//                                 isExpanded: true,
//                                  ),
//                  DropdownButton(hint: Text('Select a time'), value: selected_time,
//                                 items: _time.map((time) {
//                                      return DropdownMenuItem(child: Text(time), value: time);}).toList(),
//                                  onChanged: (newValue) {
//                                   setState(() {
//                                    selected_time = newValue;});},
//                                  isExpanded: true,),
                  RaisedButton(
                    child: (selected_date == null) ? Text("Select Date") : Text(selected_date.toString().substring(0, 10)),
                    onPressed: () {selectDate(context);},
                  ),
                  RaisedButton(
                    child: (selected_time == null) ? Text("Select Time") : Text(selected_time.format(context)),
                    onPressed: () {selectTime(context);},
                  ),
                  SizedBox(height: 100.0),
                  RaisedButton(child: Text("Check In"),
                               color: Colors.white,
                               onPressed: (){
                               setState(() {SubmitCheckIn(context);});},)
                  ]);
  }

  Future<Null> selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: Now,
        firstDate: Now,
        lastDate: Now.add(Duration(days: 14))
    );

    if(picked != null && picked != selected_date){
      setState(() {
        selected_date = picked;
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );

    if(picked != null && picked != selected_time){
      setState(() {
        selected_time = picked;
      });
    }
  }

  Widget _handlefuture(BuildContext context){
     if(isClicked)
       {
         return allentest(context);
       }
     else
       {
         return CheckInForm(context);
       }
  }
  ///Builds the UI objects on the screen.
  ///
  ///This function is called anytime something on the screen
  ///affects these UI objects. Returns the UI objects to be displayed.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Future.wait([IsUserCheckedIn()]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
               if(!CheckedIn) {
                 if (isClicked == false) {
                   return CheckInForm(context);
                 }
                 else {
                   return allentest(context);
                 }
               }
               else
                 {
                   return CheckedInPage(context);
                 }
              }
              else {
                return new CircularProgressIndicator();
              }
            }
            else {
              print("No data");
              return new CircularProgressIndicator();
            }
          }
      ),
    );
  }

  ///Checks if user is checked in.
  ///
  /// Gets the list of checkins from the url and checks that against
  /// the user's email. Returns true if the user has checked in and
  /// false if the user is not checked in.
  Future<bool> IsUserCheckedIn() async{
//    List<CheckIn> CheckInList = await widget.storage.HTTPToCheckInList("http://www.json-generator.com/api/json/get/ceqqYtrZfm?indent=2");
//        for(CheckIn checkIn in CheckInList){
//          if(checkIn.email == await GetPrefEmail()){
//            return true;
//          }
//        }
    return false;
  }

  ///Creates a form for the user to check in.
  ///
  /// Asks the user about special requests for this haircut.
  /// Returns a widget with this form.

  ///Checks the user in and shows the information.
  ///
  /// Creates a new checkin and shows a dialog with that information.
  /// The user can then click continue to see that they are checked in.
  Future SubmitCheckIn(BuildContext context) async
  {
    Appointment myappointment = Appointment(await getUserID(), selected_date.toIso8601String(), selected_time.format(context), description);
    addData({'UserID': myappointment.getUser_id(),
             'Date': myappointment.getDate(),
             'Time': myappointment.getTime(),
             'Note': myappointment.getNotes() });

    setState(() {
      CheckedIn = true;
    });
//    final NewCheckIn = new CheckIn(
//        await GetPrefEmail(),
//        DateTime.now().toUtc().toString(),
//        DescriptCont.text,
//    );
//    return showDialog(
//      context: context,
//      barrierDismissible: false,
//      builder: (context) {
//        return AlertDialog(
//          //content: Text(jsonEncode(NewCheckIn.toJson())),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Continue'),
//              onPressed: () {
//                Navigator.of(context).pop();
//                setState(() {
//                  CheckedIn = true;
//                });
//              },
//            ),
//          ],
//        );
//      },
//    );
  }

  Future<String> getUserID() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserID") ?? "";
  }

  ///Shows the user they are checked in.
  Widget CheckedInPage(BuildContext context){
    return Text("You are checked in.");
  }
}