import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/rendering.dart';

var url = 'https://next.json-generator.com/api/json/get/EyBSiFo_L';


void main() {
  // debugPaintSizeEnabled=true;
  runApp(MyApp());
}


Future<User> getUserFromResponse(url) async {
  http.Response resp = await http.get(url);
  var userJson = json.decode(resp.body);
  var user = User.fromJson(userJson[0]);
  return user;
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile Container',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
          actions: <Widget>[
            Icon(Icons.edit)
          ],
        ),
        body: BuildFromUserFuture(),
      )
    );
  }
}


class BuildFromUserFuture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BuildFromUserFutureState();
}


class _BuildFromUserFutureState extends State<BuildFromUserFuture> {
  final _leadingStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18
  );

  @override
  Widget build(BuildContext context) {
    // TODO: Move async call outside of State.build
    Future<User> user = getUserFromResponse(url);
    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: 
            return Container(
                child: Text('Starting connection...')
              );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
                child: Text('Loading...')
            ); 
          case ConnectionState.done:
            // Check for valid snapshot state
            if (snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            else {
              // Use snapshot data to populate user profile display
              return Container(
                alignment: Alignment.center,
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        // margin: EdgeInsets.only(top: 8.0),
                        child: ListView(
                          children: [
                            _buildProfileImageStack(snapshot.data, context),                      
                            _buildUserInfoCard(snapshot.data)
                          ]
                        )
                      ) 
                    )
                  ],
                )
              );
            }
          }
      }
    );
  }

  Widget _buildUserInfoCard(User user) {
    return Card(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              leading: Text('Name', style: _leadingStyle),
              title: Text(user.name),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              leading: Text('ID', style: _leadingStyle),
              title: Text(user.id.toString()),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              leading: Text('Phone', style: _leadingStyle),
              title: Text(user.phoneNumber),
            ),
            Divider(color: Colors.grey,),
            ExpansionTile(
              key: PageStorageKey<String>('_Visits'),
              leading: Text('Visits', style: _leadingStyle),
              title: Text(user.visits.length.toString()),
              children: _buildExpansionList(user),
            ),
          ]
        )
      )
    );
  }

  List<Widget> _buildExpansionList(User user) {
    List<Widget> rowList = [];
    for(int i = 0; i < user.visits.length; i++){
      rowList.add(
        Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(4.0),  
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(user.visits[i]['timestamp'], style:_leadingStyle)
                    ],),
                    Wrap(children: <Widget>[
                      Text(user.visits[i]['notes'])
                    ],)
                  ],
                )
              )
            )
          ],
        )
      );
      if(i + 1 != user.visits.length){
        rowList.add(Divider(color: Colors.grey,));
      }
    }
    return rowList;
  }

  Widget _buildProfileImageStack(User user, BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            child: Row(
              children: <Widget>[
                Container( //profile img and box containing it
                  margin: EdgeInsets.all(12.0),
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    image: DecorationImage(
                      image: NetworkImage(
                        user.picture
                      ),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ]
                  )
                ),
                Flexible(
                  child: Wrap(  
                    children: <Widget>[
                      Text( //profile name
                        user.name,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            )
          )
        ]
      )
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    //sets the top background color behind profile img/name
    path.lineTo(0.0, size.height / 3.5);
    path.lineTo(size.width, size.height/3.5);
    path.lineTo(size.width,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}


class User {
  int id;
  String fName;
  String lName;
  String phoneNumber;
  String picture;
  String birthday;
  List<dynamic> uploads;
  List<dynamic> visits;

  User(this.id, this.fName, this.lName, this.picture, this.birthday,
      this.uploads, this.visits);

  User.fromJson(Map json)
    : id = json['id'],
      fName = json['name']['first'],
      lName = json['name']['last'],
      phoneNumber = json['telephone'],
      // picture = json['picture'],
      picture = 'https://randomuser.me/api/portraits/men/60.jpg',
      birthday = json['birthday'],
      uploads = json['uploads'],
      visits = json['visits'];

  Map toJson() => {
    'id': id,
    'picture': picture,
    'birthday': birthday,
    'uploads': uploads,
    'name': {'fname': fName, 'lname': lName},
    'visits': visits
  };

  String get name => fName + ' ' + lName;
}
