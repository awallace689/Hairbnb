import 'package:flutter/material.dart';
import 'Storage.dart';
import 'CheckIn.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInPage extends StatefulWidget {
  final Storage storage;

  CheckInPage({Key key, @required this.storage}) : super(key: key);

  CheckInPageState createState() => CheckInPageState();
}

class CheckInPageState extends State<CheckInPage> {
  bool CheckingIn = false;
  bool CheckedIn = false;
  final DescriptCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Future.wait([IsUserCheckedIn()]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                //if(snapshot.data[0] == false){
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
              return new CircularProgressIndicator();
            }
          }
      ),
    );
  }

  Future<bool> IsUserCheckedIn() async{
    List<CheckIn> CheckInList = await widget.storage.HTTPToCheckInList("http://www.json-generator.com/api/json/get/ceqqYtrZfm?indent=2");
    for(CheckIn checkIn in CheckInList){
      if(checkIn.email == await GetPrefEmail()){
        return true;
      }
    }
    return false;
  }

  Future<String> GetPrefEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("EmailLogin") ?? "";
  }

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

  Future SubmitCheckIn(BuildContext context) async
  {
    final NewCheckIn = new CheckIn(
        await GetPrefEmail(),
        DateTime.now().toUtc().toString(),
        DescriptCont.text,
    );
    //String user = jsonEncode(NewUser.toJson());
    //print((await HTTP.post("https://api.myjson.com/bins", body: user)).body);
    //print(user);
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

  Widget CheckedInPage(BuildContext context){
    return Text("You are checked in.");
  }
}