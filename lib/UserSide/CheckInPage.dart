import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';

///A class contains one static function, which is used to verify
///the user's input over the text field.
///
///Test user's input over the text field,
///and returns a designed string depend on the value passed in.
class DescriptionValidator{
  static String validate(String note){
    return note==null ? "Description can not be empty!" : note;
  }
}

///A class contains one static function, which is used to verify
///whether the user has selected a date for appointment or not.
///
///Test whether the user has selected a date or not,
///and returns a designed string depend on the value passed in.
class DateValidator{
  static String validate(DateTime date){
    return date==null ? "Please select a date!" : null;
  }
}

///A class contains one static function, which is used to verify
///whether the user has selected a time for appointment or not.
///
///Test whether the user has selected a time or not,
///and returns a designed string depend on the value passed in.
class TimeValidator{
  static String validate(TimeOfDay time){
    return time==null ? "Please select a time!" : null;
  }
}

///Creates a page for the user to check in.
class CheckInPage extends StatefulWidget {

  const CheckInPage({this.testing});
  final VoidCallback testing;

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
  Appointment myappointment;
  List<String> _date = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  List<String> _time = ['9:15 am', '9:30 am', '9:45 am', '10:00 am', '10:15 am', '10:30 am', '10:45 am',
                        '11:00 am', '11:15 am', '11:30 am', '11:45 am', '12:00 pm', '12:15 pm', '12:30 pm'];
  final DescriptCont = TextEditingController();


  //Store a already mapped object to a designated Firestore's
  //collection as a brand new document, and to store the created appointment's
  //information to the user's document.
  Future<void> addData(appointment) async{

    DocumentReference ref = Firestore.instance.collection("Appointment").document();
    print(ref.documentID);

    //Add appointment document to appointment collection with a new documentID
    //Firestore.instance.collection("Appointment").document(ref.documentID).setData(appointment);
    ref.setData(appointment);
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


  ///Open gallery of the user's smart phone.
  ///
  /// Allows the user to select a photo from their device's gallery.
   imgCapture() async
  {
     File img = await ImagePicker.pickImage(source: ImageSource.gallery);
     _cropImage(img);
  }

  ///Opens a screen where the user crops the image they selected.
  ///
  /// Crops the image to be a square.
  /// Store the selected image by the user to variable user_image.
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

  ///Returns a Scaffold widget that contain a check in button,
  ///and once the button is clicked, re-build of the current page is triggered.
  Widget CheckInForm(BuildContext context){
    return Scaffold(backgroundColor: Theme.of(context).primaryColor,
        body:Center(
            child: SizedBox(width: 200.0, height: 200.0,
                child: FloatingActionButton(key: Key('CheckIn'),
                    backgroundColor: Colors.white,
                    child:Text("Check in"),
                    foregroundColor: Colors.black ,
                    onPressed: () => {setState(() {
                       isClicked=true;
                    })})
            ))
    );
  }

  ///Returns a ListView widget that contains a container widget to show image
  ///user has selected from the gallery, contains a text field for the user to
  ///enter special request for his/her haircut, and contains two buttons that
  ///the users can click and select the date and time for their haircuts respectively.
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
                  RaisedButton(
                    child: (selected_date == null) ? Text("Select Date") : Text(selected_date.toString().substring(0, 10)),
                    onPressed: () {selectDate(context);},
                  ),
                  RaisedButton(
                    child: (selected_time == null) ? Text("Select Time") : Text(selected_time.format(context)),
                    onPressed: () {selectTime(context);},
                  ),
                  SizedBox(height: 100.0),
                  RaisedButton(key:   Key('submit'),
                               child: Text("Check In"),
                               color: Colors.white,
                               onPressed: (){
                               setState(() {SubmitCheckIn(context);});},)
                  ]);
  }

  ///Triggers the showDatePicker method, and stores the selected date to the
  ///variable selected_date.
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

  ///Triggers the showTimePicker method, and stores the selected time to the
  ///variable selected_time.
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

  ///Builds the UI objects on the screen.
  ///
  ///This function is called anytime something on the screen
  ///affects these UI objects. Returns the UI objects to be displayed.
  @override
  Widget build(BuildContext context) {

    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection("Appointment").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return (CheckedIn) ?
              Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Upcoming Appointment\n", style: TextStyle(fontSize: 30),),
                        Container(
                            width: 250.0,
                            height: 250.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(user_image)
                                )
                            )
                        ),
                        Container(height: 10, width: 0,),
                        Text(myappointment.date.substring(0, 10) + " " + myappointment.time, style: TextStyle(fontSize: 25),),
                        Text("Notes:", style: TextStyle(fontSize: 20),),
                        Text(myappointment.notes, style: TextStyle(fontSize: 18),)
                      ],
                    ),
                  )
              ):
              FutureBuilder(
                future: IsUserCheckedIn(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.data != null){
                    CheckedIn = false;
                    if(snapshot.data == false){
                      return (isClicked) ? allentest(context) : CheckInForm(context);
                    }
                    else{
                      return CheckedInPage(context, snapshot.data);
                    }
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              );
            }
            else {
              return new CircularProgressIndicator();
            }
          }
      ),
    );
  }

  ///Compare function for appointments to be passed into a sort.
  ///
  /// Compares two DocumentSnapshots and compares them based on the time and date.
  int CompareAppointments(DocumentSnapshot a, DocumentSnapshot b){
    int aHour = int.parse(a['Time'].split(":")[0]);
    if(a['Time'].indexOf('PM') != -1) aHour += 12;

    int aMinute = int.parse(a['Time'].split(":")[1].substring(0, 2));

    int bHour = int.parse(b['Time'].split(":")[0]);
    if(b['Time'].indexOf('PM') != -1) bHour += 12;

    int bMinute = int.parse(b['Time'].split(":")[1].substring(0, 2));

    DateTime aDate = DateTime.parse(a['Date']).add(Duration(hours: aHour, minutes: aMinute));
    DateTime bDate = DateTime.parse(b['Date']).add(Duration(hours: bHour, minutes: bMinute));
    if(aDate.isBefore(bDate)) return -1;
    else return 1;
  }

  ///Checks if user is checked in.
  ///
  /// Gets the list of checkins from the url and checks that against
  /// the user's email. Returns the appointment data if the user has checked in and
  /// false if the user is not checked in.
  Future IsUserCheckedIn() async{
    List<DocumentSnapshot> Appointments = (await Firestore.instance.collection('Appointment').getDocuments()).documents;
    Appointments.sort((a, b) => CompareAppointments(a, b));
    for(DocumentSnapshot appointment in Appointments){
      if(appointment.data['UserID'] == await getUserID()){
        return appointment;
      }
    }
    return false;
  }

  ///Checks the user in and shows the information.
  ///
  /// Creates a new checkin and shows a dialog with that information.
  /// The user can then click continue to see that they are checked in.
  Future SubmitCheckIn(BuildContext context) async
  {
    bool flag = false;
    String temp_description = DescriptionValidator.validate(description);
    String temp_date = DateValidator.validate(selected_date);
    String temp_time = TimeValidator.validate(selected_time);

    if(user_image == null){
      flag = true;
      return showDialog(context: context, barrierDismissible: false, builder: (context){
        return AlertDialog(title: Text("You must add a photo."), actions: <Widget>[FlatButton(child: Text('OK'), onPressed: () {Navigator.of(context).pop();} )]);
      });
    }
    if(temp_description == "Description can not be empty!")
      {
        flag = true;
        return showDialog(context: context, barrierDismissible: false, builder: (context){
          return AlertDialog(title: Text(temp_description), actions: <Widget>[FlatButton(child: Text('OK'), onPressed: () {Navigator.of(context).pop();} )]);
        });
      }
    if(!flag && temp_date == "Please select a date!")
      {
        flag = true;
        return showDialog(context: context, barrierDismissible: false, builder: (context){
          return AlertDialog(title: Text(temp_date), actions: <Widget>[FlatButton(child: Text('OK'), onPressed: () {Navigator.of(context).pop();} )]);
        });
      }
    if(!flag && temp_time == "Please select a time!")
      {
        flag = true;
        return showDialog(context: context, barrierDismissible: false, builder: (context){
          return AlertDialog(title: Text(temp_time), actions: <Widget>[FlatButton(child: Text('OK'), onPressed: () {Navigator.of(context).pop();} )]);
        });
      }
    print(flag);
    if(!flag)
    {
      myappointment = Appointment(await getUserID(), selected_date.toIso8601String(), selected_time.format(context), description);
      addData({'UserID': myappointment.getUser_id(),
             'Date': myappointment.getDate(),
             'Time': myappointment.getTime(),
             'Note': myappointment.getNotes() });

      setState(() {
        CheckedIn = true;
      });
    }
  }

  ///Return the user ID is currently logged in to the page.
  ///User ID is being stored in SharedPreferences beforehand when the user tries
  ///to log in.
  Future<String> getUserID() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserID") ?? "";
  }

  ///Shows the user they are checked in.
  Widget CheckedInPage(BuildContext context, DocumentSnapshot appointment){
    //return Text(appointment.toString());
    return FutureBuilder(
      future: getAppointmentPhotoURL(appointment),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data != null){
          return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
              color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Upcoming Appointment\n", style: TextStyle(fontSize: 30),),
                  Container(
                      width: 250.0,
                      height: 250.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot.data)
                          )
                      )
                  ),
                  Container(height: 10, width: 0,),
                  Text(appointment.data['Date'].toString().substring(0, 10) + " " + appointment.data['Time'], style: TextStyle(fontSize: 25),),
                  Text("Notes:", style: TextStyle(fontSize: 20),),
                  Text(appointment.data['Note'], style: TextStyle(fontSize: 18),)
                ],
              ),
            )
          );
        }
        else{
          return CircularProgressIndicator();
        }
      },
    );
  }

  ///Retrieves the url of the photo uploaded for the appointment.
  ///
  /// Takes a DocumentSnapshot and uses the information to fetch the
  /// url of the photo uploaded from the Firestore reference.
  Future<String> getAppointmentPhotoURL(DocumentSnapshot appointment) async{
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
        .child("/${appointment.data['UserID']}/${appointment.documentID}.jpg");
    final profilePicUrl = await firebaseStorageRef.getDownloadURL();
    print(profilePicUrl);
    return profilePicUrl;
  }
}