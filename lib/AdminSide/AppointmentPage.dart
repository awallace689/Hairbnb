import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../UserSide/User.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

///Creates a stateful widget to hold the appointment page.
class AppointmentPage extends StatefulWidget {
  @override
  AppointmentPageState createState() => AppointmentPageState();
}

///Appointment page contents.
class AppointmentPageState extends State<AppointmentPage> {

  ///Creates the scaffold to hold the list of appointments.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Appointments"),
      ),
      body: Container(
        color: Colors.green,
        child: StreamBuilder(
          stream: Firestore.instance.collection('Appointment').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot != null){
              if(snapshot.data != null && snapshot.data != []){
                return CreateListOfAppointments(snapshot.data.documents);
              }
              else{
                return Text("No Appointments");
              }
            }
            else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );

  }

  ///Compares two appointments.
  ///
  /// Passed into a sort method to sort a list of appointments.
  /// If a is before b returns -1, else returns 1.
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

  ///Creates a list of appointment widgets.
  ///
  /// From a list of appointment data, creates a listview with
  /// children as a list of cards created from the data.
  ListView CreateListOfAppointments(List<dynamic> AppointmentList)
  {
    List<Widget> AppList = List<Widget>();
    AppointmentList.sort((a, b) => CompareAppointments(a, b));
    for(final appointment in AppointmentList){
      final app = FutureBuilder(
        future: CreateAppointmentCard(appointment),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if(snapshot.data == null){
            return Container();
          }
          else{
            return snapshot.data;
          }
        },
      );
      AppList.add(app);
    }
    return ListView(
      itemExtent: 100.0,
      children: AppList,
    );
  }

  ///Creates a card with information about the appointment.
  ///
  /// This card contains the information about the appointment
  /// and when clicked shows more information in a dialog.
  Future<Widget> CreateAppointmentCard(dynamic appointment) async{
    final AppointmentID = appointment.documentID;
    final UserID = appointment.data['UserID'];
    final Notes = appointment.data['Note'];
    final Time = appointment.data['Time'];
    final userMap = (await Firestore.instance.collection('users').document(UserID).get()).data;
    final image = await AppointmentImage(userMap['userid']);
    final subTitle = Text(Notes.substring(0, (Notes.toString().length >= 30) ? 30 : Notes.toString().length) + "...");
    final name = Text(userMap['name']['first'] + " " + userMap['name']['last']);

    return MaterialButton(
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: image,
          title: name,
          subtitle: subTitle,
        ),
      ),
      onPressed: () {ShowAppointmentInfo(userMap, appointment);},
    );
  }

  ///Displays a dialog with more appointment information.
  Future ShowAppointmentInfo(Map user, dynamic appointment) async{
    final dialog = MyDialogContent(data: [user, await AppointmentImage(user['userid']), appointment]);
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  ///Creates a widget that contains the profile picture image.
  Future<Widget> AppointmentImage(String userID) async{
    final profilePicUrl = await getImageURL('profilePicture', userID);
    return Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(profilePicUrl)
            )
        )
    );
  }
}

///Creates a dialog with the appointment information.
class MyDialogContent extends StatefulWidget {
  MyDialogContent({Key key, this.data,}): super(key: key);

  final List<dynamic> data;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

///Creates the content of the appointment dialog.
class _MyDialogContentState extends State<MyDialogContent> {
  bool ImageFullScreen = false;

  ///Initializes the state of the dialog.
  @override
  void initState(){
    super.initState();
  }


  ///Creates a widget of the image of the appointment.
  Future<Widget> HaircutImage(String UserID, String appointmentID) async{
    return RawMaterialButton(
        onPressed: () {
          setState(() {
            ImageFullScreen = true;
          });
        },
        child: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(await getImageURL(appointmentID, UserID))
                )
            )
        ),
        shape: new CircleBorder(),
        elevation: 5.0,
        fillColor: Colors.green,
        padding: EdgeInsets.all(0)
    );
  }

  ///Builds the widget of the dialog.
  ///
  /// Creates a dialog with information about the appointment.
  /// The dialog contains a button to dismiss the dialog and
  /// a button to complete the appointment.
  @override
  Widget build(BuildContext context) {
    Map user = widget.data[0];
    dynamic appointment = widget.data[2];
    return FutureBuilder(
      future: Future.wait([HaircutImage(user['userid'], appointment.documentID), getImageURL(appointment.documentID, user['userid'])]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == null){
          return Container();
        }
        else{
          final Content = (ImageFullScreen) ?
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height: 350.0,
              width: 600.0,
              child: MaterialButton(
                child: Image.network(snapshot.data[1]),
                onPressed: () {
                  setState(() {
                    ImageFullScreen = false;
                  });
                },
              ),
            ),
          ):
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
            content: SingleChildScrollView(
              child: Container(
              height: 600.0,
              width: 600.0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: widget.data[1],
                        title: Text(widget.data[0]['name']['first'] + " " + widget.data[0]['name']['last'], style: TextStyle(fontSize: 25),),
                      ),
                      Container(height: 15,),
                      Text(DateTime.parse(appointment['Date']).toIso8601String().substring(0, 10) + " " + appointment['Time']),
                      Container(height: 15,),
                      Container(height:2, color: Colors.green,),
                      Container(height: 15,),
                      Center(
                        child: snapshot.data[0],
                      ),
                      Text("Notes:", style: TextStyle(fontSize: 25),),
                      Container(height: 15,),
                      Container(
                        child: Text(appointment.data['Note']),
                      ),

                    ],
                ),
              ),
            ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                child: Text('Complete Appointment', style: TextStyle(color: Colors.white),),
                onPressed: (){CompleteAppointment(appointment.documentID);},
              ),
              FlatButton(
                color: Colors.red,
                child: Text('Close', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          return Content;
        }
      },
    );
  }

  ///Removes the appointment form the appointment list in firestore.
  Future<Null> CompleteAppointment(String appointmentID) async{
    Firestore.instance.collection('Appointment').document(appointmentID).delete();
    Navigator.of(context).pop();
  }
}

///Retrieves the image from firestore.
///
/// Returns the download link of the image in firestore with path
/// "/[UserID]/[imageName].jpg"
Future<String> getImageURL(String imageName, String UserID) async{
  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
      .child("/$UserID/$imageName.jpg");
  final profilePicUrl = await firebaseStorageRef.getDownloadURL();
  return profilePicUrl;
}