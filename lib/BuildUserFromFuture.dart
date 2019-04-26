import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';
import 'package:firebase_storage/firebase_storage.dart';


/// url {String}: static URL for loading json into User class
var url = 'https://next.json-generator.com/api/json/get/EyBSiFo_L';

/// BuildFromUserFuture {StatefulWidget}: StatefulWidget creates 
/// state for User 'Your Profile' page.
class BuildFromUserFuture extends StatefulWidget {
  /// Returns State<StatefulWidget> from _BuildFromUserFutureState for
  /// displaying User 'Your Profile' page.
  @override
  State<StatefulWidget> createState() => _BuildFromUserFutureState();
}

/// Build returns FutureBuilder which returns 'loading...' if async call to
/// JSON server not yet finished, else displays user profile image,
/// name, user ID, telephone number, and visit history/notes.
/// 
/// Methods:
///   Public:
///     *Widget build(BuildContext context)
///   Private:
///     *Widget _buildUserInfoCard(User user)
///     *List<Widget> _buildExpansionList(User user)
///     *Widget _buildProfileImageStack(User user, BuildContext context)
/// 
class _BuildFromUserFutureState extends State<BuildFromUserFuture> {
  /// TextStyle object for formatting headers within 'Your Profile' page.
  final _leadingStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18
  );

  /// Returns a FutureBuilder Widget responsible for displaying 'loading...'
  /// while async call to JSON server is made, then upon completion builds
  /// User 'Your Profile' page with the received information.
  /// 
  /// param context {BuildContext}: BuildContext received from MaterialApp
  /// return: Widget (FutureBuilder)
  @override
  Widget build(BuildContext context) {
    Future<FBUser> user = getFBUserFromPreferences();
      return FutureBuilder(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<FBUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator()
              );
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator()
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

  /// Returns Card containing divided ListTiles holding user info, as well
  /// as an ExpansionTile build by function _buildExpansionList.
  /// 
  /// param user {User}: user to pull data from
  /// return: Widget (Card)
  Widget _buildUserInfoCard(FBUser user) {
    return Card(
        child: Container(
            margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    leading: Text('Name', style: _leadingStyle),
                    title: Text(user.name['first'] + ' ' + user.name['last']),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    leading: Text('ID', style: _leadingStyle),
                    title: Text(user.userid), //TODO: Remove after testing
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    leading: Text('Email', style: _leadingStyle),
                    title: Text(user.email),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    leading: Text('Phone', style: _leadingStyle),
                    title: Text(user.phoneNumber),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    leading: Text('Birthday', style: _leadingStyle),
                    title: Text(user.birthday),
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

  /// Iterate though each visit stored within user and build a corresponding
  /// Row with timestamp and text-wrap supporting notes section.
  /// 
  /// param user {User}: User object to pull information from
  /// return: List<Widget>, a list of Rows
  List<Widget> _buildExpansionList(FBUser user) {
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

  /// Returns a contained Stack which displays formatted user profile image,
  /// name, and a background color defined by the top-most container.
  /// 
  /// param user {User}: User to pull information from
  /// param context {BuildContext}: BuildContext from MaterialApp
  /// return: Widget (Container)
  Widget _buildProfileImageStack(FBUser user, BuildContext context) {
    return 
    Card(
      child: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [ 0.2, 0.3, 0.4, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.green[100],
              Colors.green[100],
              Colors.green[100],
              Colors.green[100],
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(12.0),
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/hairbnb-f0c2c.appspot.com/o/l8jj6JC66fgjQ1y3Q7abMxwiqxX2%2FprofilePicture.jpg?alt=media&token=c01dc283-e44b-4ae0-a5e8-4307bc6249b7'
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
                          user.name['first'] + ' ' + user.name['last'],
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
      )
    );
  }
}

/// Given a compatible, decoded JSON, User.fromJson will create itself
/// using the information contained within.
/// 
/// Methods:
///   Public:
///     *User(this.id, this.fName, this.lName, this.picture, this.birthday,
///          this.uploads, this.visits)
///     *User.fromJson(Map json)
///     *Map toJson()
///   
/// Properties:
///   int id: user id
///   String fName: first name
///   String lName: last name
///   String name: full name
///   String phoneNumber: phone number
///   String birthday: [unused] user birth date
///   List<dynamic> uploads: [unused] List of user-uploaded photos
///   List<dynamic> visits: List of Maps holding user visit timestamp and notes
class User {
  int id;
  String fName;
  String lName;
  String phoneNumber;
  String picture;
  String birthday;
  List<dynamic> uploads;
  List<dynamic> visits;

  /// Default constructor for manually creating User class
  User(this.id, this.fName, this.lName, this.picture, this.birthday,
      this.uploads, this.visits);

  /// Create User from json map provided by convert.json.decode
  User.fromJson(Map json)
    : id = json['id'],
      fName = json['name']['first'],
      lName = json['name']['last'],
      phoneNumber = json['telephone'],
      picture = 'https://randomuser.me/api/portraits/men/60.jpg',
      birthday = json['birthday'],
      uploads = json['uploads'],
      visits = json['visits'];

  /// [Incomplete]
  /// Export User fields as Json
  Map toJson() => {
    'id': id,
    'picture': picture,
    'birthday': birthday,
    'uploads': uploads,
    
    'name': {'fname': fName, 'lname': lName},
    'visits': visits
  };

  /// Get full name from existing fields
  String get name => fName + ' ' + lName;
}

/// [async]
/// Return a Future<User> from http.get request for
/// user with FutureBuilder
/// 
/// param url {String}: url to make request to
/// return: Future<User>
Future<FBUser> getFBUserFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DocumentSnapshot document = await Firestore.instance
                                .collection('users').document(prefs.get("UserID")).get();
  FBUser user = FBUser.fromFB(document.data);
  user.getProfilePicUrl.then(
    (param) {
        user.profilePicUrl = param;
    }
  );
  return user;
}