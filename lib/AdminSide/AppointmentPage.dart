import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../UserSide/User.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

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

  ListView CreateListOfAppointments(List<dynamic> AppointmentList)
  {
    List<Widget> AppList = List<Widget>();
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

  Future<Widget> CreateAppointmentCard(dynamic appointment) async{
    final AppointmentID = appointment.documentID;
    final UserID = appointment.data['UserID'];
    final Notes = appointment.data['Note'];
    final Time = appointment.data['Time'];
    final userMap = (await Firestore.instance.collection('users').document(UserID).get()).data;
    //print(userMap["pastVisits"]);
    //User user = User(userMap['email'], userMap['name'], userMap['phoneNumber'], userMap['birthday'], userMap['pastVisits'], userMap['userid']);
    //User user = User.fromMap(userMap);
    //print("!!!!!!!!!!!!!");
    //print(user.toString());
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

  Future ShowAppointmentInfo(Map user, dynamic appointment) async{
    final dialog = MyDialogContent(data: [user, await AppointmentImage(user['userid']), appointment]);
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> AppointmentImage(String userID) async{
    final profilePicUrl = await getImageURL('profilePicture', userID);
    print(profilePicUrl);
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

class MyDialogContent extends StatefulWidget {
  MyDialogContent({Key key, this.data,}): super(key: key);

  final List<dynamic> data;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  bool ImageFullScreen = false;

  @override
  void initState(){
    super.initState();
  }


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
                    image: NetworkImage(await getImageURL('profilePicture', UserID))
                )
            )
        ),
        shape: new CircleBorder(),
        elevation: 5.0,
        fillColor: Colors.green,
        padding: EdgeInsets.all(0)
    );
  }

  @override
  Widget build(BuildContext context) {
    Map user = widget.data[0];
    dynamic appointment = widget.data[2];
    return FutureBuilder(
      future: Future.wait([HaircutImage(user['userid'], appointment.documentID), getImageURL('profilePicture', user['userid'])]),
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
                      Container(height:2, color: Colors.green,),
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

  Future<Null> CompleteAppointment(String appointmentID) async{
    Firestore.instance.collection('Appointment').document(appointmentID).delete();
    Navigator.of(context).pop();
  }
}

Future<String> getImageURL(String imageName, String UserID) async{
  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
      .child("/$UserID/$imageName.jpg");
  final profilePicUrl = await firebaseStorageRef.getDownloadURL();
  return profilePicUrl;
}