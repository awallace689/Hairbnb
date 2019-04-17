import 'package:flutter/material.dart';
import 'Storage.dart';
import 'CheckIn.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

///Creates a page for the user to check in.
class CheckInPage extends StatefulWidget {
  final Storage storage;

  CheckInPage({Key key, @required this.storage}) : super(key: key);

  CheckInPageState createState() => CheckInPageState();
}

///Implementation of the CheckInPage class.
///
///Shows a button to be clicked to checkin and fill out a form.
class CheckInPageState extends State<CheckInPage> {
  bool CheckingIn = false;
  bool CheckedIn = false;
  final DescriptCont = TextEditingController();

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
                if(!CheckedIn){
                  return CheckInForm(context);
                }
                else{
                  return CheckedInPage(context);
                }
              } else {
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
  Widget CheckInForm(BuildContext context){
    return Center(
      child: ListView(
        children: <Widget>[
          !CheckingIn ? RaisedButton(
            child: Text("Check In"),
            onPressed: () {setState(() {
              CheckingIn = !CheckingIn;
            });},
          ) : Container(),

          CheckingIn ? Center(
            child: Column(
              children: <Widget>[
                Text("Special requests:"),
                TextFormField(
                  controller: DescriptCont,
                  decoration: InputDecoration(
                    hintText: "Description of your haircut."
                  ),
                  maxLines: 4,

                ),
                RaisedButton(
                  child: Text("Check In"),
                  onPressed: (){
                    setState(() {
                      SubmitCheckIn(context);
                    });
                  },
                )
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  ///Checks the user in and shows the information.
  ///
  /// Creates a new checkin and shows a dialog with that information.
  /// The user can then click continue to see that they are checked in.
  Future SubmitCheckIn(BuildContext context) async
  {
    final NewCheckIn = new CheckIn(
        await GetPrefEmail(),
        DateTime.now().toUtc().toString(),
        DescriptCont.text,
    );
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(jsonEncode(NewCheckIn.toJson())),
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