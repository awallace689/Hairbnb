import 'package:flutter/material.dart';
import 'CheckIn.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_firestore.dart';

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
  String selected_date;
  String selected_time;
  String description;
  List<String> _date = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  List<String> _time = ['9:15 am', '9:30 am', '9:45 am', '10:00 am', '10:15 am', '10:30 am', '10:45 am',
                        '11:00 am', '11:15 am', '11:30 am', '11:45 am', '12:00 pm', '12:15 am', '12:30 am'];
  final DescriptCont = TextEditingController();

  Future<void> addData(appointment) async{
    
    Firestore.instance.runTransaction((Transaction apptransaction) async{
    CollectionReference reference = await Firestore.instance.collection('Appointment');
    reference.add(appointment);});
  }

   imgCapture() async
  {
     File img = await ImagePicker.pickImage(source: ImageSource.gallery);
     if(img != null) {
       user_image = img;
       setState(() {});
     }

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
                  GestureDetector(onTap: imgCapture,
                  child: CircleAvatar(child:
                  user_image == null?Text("Click to add an image"):Image.file(user_image), radius: 80.0,
                    backgroundColor:Colors.white,
                    foregroundColor:Colors.black,)),
                  SizedBox(height: 20.0),
                  Row(children: <Widget>[Text("Special requests:", style: TextStyle(fontWeight: FontWeight.bold),
                                                textScaleFactor: 1.4,)],),
                  SingleChildScrollView (child:
                  TextField(controller: DescriptCont, onChanged: (note){description=note;} , decoration: InputDecoration(
                  hintText: "Description of your haircut."),  maxLines: 4)),
                  Row(children: <Widget>[Text("Schedule a time:", style: TextStyle(fontWeight: FontWeight.bold),
                                         textScaleFactor: 1.4,)],),
                  DropdownButton(hint: Text('Select a date'), value: selected_date,
                                 items: _date.map((date) {
                                      return DropdownMenuItem(child: Text(date), value: date);}).toList(),
                                 onChanged: (newValue) {
                                   setState(() {
                                     selected_date = newValue;
                                   });},
                                 isExpanded: true,
                                  ),
                  DropdownButton(hint: Text('Select a time'), value: selected_time,
                                 items: _time.map((time) {
                                      return DropdownMenuItem(child: Text(time), value: time);}).toList(),
                                  onChanged: (newValue) {
                                   setState(() {
                                    selected_time = newValue;});},
                                  isExpanded: true,),
                  SizedBox(height: 100.0),
                  RaisedButton(child: Text("Check In"),
                               color: Colors.white,
                               onPressed: (){
                               setState(() {SubmitCheckIn(context);});},)
                  ]);
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

  ///Gets the email from the app's preferences.
  Future<String> GetPrefEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("EmailLogin") ?? "";
  }

  ///Creates a form for the user to check in.
  ///
  /// Asks the user about special requests for this haircut.
  /// Returns a widget with this form.

  ///Checks the user in and shows the information.
  ///
  /// Creates a new checkin and shows a dialog with that information.
  /// The user can then click continue to see that they are checked in.
  Future SubmitCheckIn(BuildContext context)
  {
    Appointment myappointment = Appointment('12345', selected_date, selected_time, 'path', description);
    addData({'UserID': myappointment.getUser_id(),
             'Date': myappointment.getDate(),
             'Time': myappointment.getTime(),
             'ImagePath': myappointment.getImage(),
             'Note': myappointment.getNotes() });
//    final NewCheckIn = new CheckIn(
//        await GetPrefEmail(),
//        DateTime.now().toUtc().toString(),
//        DescriptCont.text,
//    );
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          //content: Text(jsonEncode(NewCheckIn.toJson())),
          actions: <Widget>[
            FlatButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  CheckedIn = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  ///Shows the user they are checked in.
  Widget CheckedInPage(BuildContext context){
    return Text("You are checked in.");
  }
}