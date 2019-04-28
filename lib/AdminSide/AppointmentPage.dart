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
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('Admin').document('Appointments').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot != null){
              if(snapshot.data != null && snapshot.data != []){
                return CreateListOfAppointments(snapshot.data['Appointments']);
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
      floatingActionButton: FloatingActionButton(
        onPressed: Add2Appointments,
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
    final AppointmentID = appointment['AppointmentID'];
    final UserID = appointment['UserID'];
    final Notes = appointment['Notes'];
    final Time = appointment['Time'];
    final userMap = (await Firestore.instance.collection('users').document(UserID).get()).data;
    User user = User.fromMap(userMap);
    final image = await AppointmentImage(user);
    final subTitle = Text(Notes.toString().substring(0, 30) + "...");
    final name = Text(user.name['first'] + " " + user.name['last']);

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
      onPressed: () {ShowAppointmentInfo(user, AppointmentID);},
    );
  }

  Future ShowAppointmentInfo(User user, String AppointmentID) async{
    final dialog = MyDialogContent(data: [user, await AppointmentImage(user)]);
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> AppointmentImage(User user) async{
    return Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(await user.getProfilePicUrl)
            )
        )
    );
  }

  void Add2Appointments() async{
    final appointment1 = {'AppointmentID': '1234567890', 'UserID': '6YvLJuTZfIf5vgBHxZkA9BZ9Rkt1', 'Time': '2019-04-27 15:50:53.377', 'Notes': 'Nunc lacinia volutpat rhoncus. Praesent varius vitae lectus bibendum venenatis. Pellentesque vitae ipsum vitae ex porta ullamcorper. Donec et nibh fermentum, aliquet risus luctus, porttitor orci. Suspendisse potenti. Nam condimentum mi id orci faucibus imperdiet. Cras varius sapien eu pharetra efficitur. Pellentesque fringilla massa quis augue tristique eleifend. Vestibulum eros dolor, mollis in placerat ut, lacinia non nulla.'};
    final appointment2 = {'AppointmentID': '1234567891', 'UserID': 'l8jj6JC66fgjQ1y3Q7abMxwiqxX2', 'Time': '2019-04-27 15:58:16.242', 'Notes': 'Nunc lacinia volutpat rhoncus. Praesent varius vitae lectus bibendum venenatis. Pellentesque vitae ipsum vitae ex porta ullamcorper. Donec et nibh fermentum, aliquet risus luctus, porttitor orci. Suspendisse potenti. Nam condimentum mi id orci faucibus imperdiet. Cras varius sapien eu pharetra efficitur. Pellentesque fringilla massa quis augue tristique eleifend. Vestibulum eros dolor, mollis in placerat ut, lacinia non nulla.'};
    List<dynamic> CurrentAppointments = (await Firestore.instance.collection('Admin').document('Appointments').get()).data['Appointments'];
    List<dynamic> NewAppointments = new List<dynamic>();
    NewAppointments.addAll(CurrentAppointments);
    NewAppointments.addAll([appointment1, appointment2]);
    Firestore.instance.collection('Admin').document('Appointments').setData({'Appointments' : NewAppointments});
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


  Future<Widget> HaircutImage(User user) async{
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
                    image: NetworkImage(await user.getProfilePicUrl)
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
    User user = widget.data[0];
    return FutureBuilder(
      future: Future.wait([HaircutImage(user), user.getProfilePicUrl]),
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
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height: 600.0,
              width: 600.0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: widget.data[1],
                        title: Text(widget.data[0].name['first'] + " " + widget.data[0].name['last'], style: TextStyle(fontSize: 25),),
                      ),
                      Container(height: 15,),
                      Container(height:2, color: Colors.green,),
                      Center(
                        child: snapshot.data[0],
                      ),
                      Text("Notes:", style: TextStyle(fontSize: 25),),
                      Container(
                        color: Colors.grey,
                        child: Text("HERE ARE THE NOTES FOR THE HAIRCUT."),
                      )
                    ]
                ),
              ),
            ),
          );
          return Content;
        }
      },
    );
  }
}
