import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';


/// url {String}: static URL for loading json into User class
var url = 'https://next.json-generator.com/api/json/get/EyBSiFo_L';

/// BuildFromUserFuture {StatefulWidget}: StatefulWidget creates 
/// state for User 'Your Profile' page.
class ProfilePage extends StatefulWidget {
  /// Returns State<StatefulWidget> from _BuildFromUserFutureState for
  /// displaying User 'Your Profile' page.
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
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
class _ProfilePageState extends State<ProfilePage> {
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
  @override //OG widget that calls the functions needed to make the page display stuff
  Widget build(BuildContext context) {
    Future<User> user = getUserFromPreferences();
      return FutureBuilder(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
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
                                      //_buildProfileImageStack(snapshot.data, context),
                                      _buildUserInfoCard(snapshot.data, context)

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
  Widget _buildUserInfoCard(User user, BuildContext context) { //begin miller's profile.
    return Container(
        margin: EdgeInsets.only(top: 0),
        child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 15),
                  Container( //profile img and box containing it
                      width: 150.0,
                      height: 150.0,
                      //left: 500,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ])),
                  SizedBox(width: 25),
                  Column(
                    children: [
                      Text( //profile name
                        user.name['first'] + ' ' + user.name['last'],
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height:5),
                      Text( //affiliation/subtext
                        'This is dummy text. Not live.',
                        style: TextStyle(
                          fontSize: 14,
                          //fontStyle: FontStyle.italic,
                          color: Colors.grey[900],

                        ),
                      ),
                    ], //column children
                  ),
                ]
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://yakimaymca.org/wp-content/uploads/2017/08/Telephone-icon-orange-300x300.png'),
                                ),
                              )
                          ),
                          SizedBox(width:12),
                          Text(
                              'Telephone: ',
                              style: TextStyle(
                                fontSize: 14,
                              )
                          ),
                          Text(
                              user.phoneNumber, //makes this a link so user can click and call someone
                              style: TextStyle(
                                fontSize: 14,

                              )
                          ),

                          //SizedBox(height: 25),
                        ], //children for row
                      ),
                      SizedBox(height:20),
                      Row(
                        children: [ //TODO: Why is there a difference between children <widget> ? seems pretty useless to use the widget one cause it just gives me errors
                          Text(
                              'Notes: ',
                              style: TextStyle(
                                fontSize: 14,
                              )
                          ),
                          myBox(),
                          //SizedBox(height:300),
                        ],
                      ),
                      SizedBox(height:20),
                      Row(
                        children: [
                          Text(
                              'Past appointments ',
                              style: TextStyle(
                                fontSize: 14,
                              )
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width*0.8,
                        child: new Column (
                          children: <Widget>[
                            Text ("This is dummy text. Not live server info.", textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                      Row(
                          children: [
                            Text(
                                'Past Haircuts',
                                style: TextStyle(
                                  fontSize: 14,
                                )
                            ),
                          ] //children
                      ),
                      SizedBox(height:15),
                      Row(
                          children: [
                            Column(
                                children: [
                                  Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://media.gq.com/photos/55958e822ca275951298731d/master/w_400,c_limit/tom-cruise-hair-08.jpg'),
                                        ),
                                      )
                                  ),
                                ]
                            ),
                            SizedBox(width:20),
                            Column(
                                children: [
                                  Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://qph.fs.quoracdn.net/main-qimg-6cdc39dfd08aa9fbfa58909a91f22b8e'),
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          ]
                      )
                    ]
                ),
              )
          ]
      )
    );
  }

  /// Iterate though each visit stored within user and build a corresponding
  /// Row with timestamp and text-wrap supporting notes section.
  /// 
  /// param user {User}: User object to pull information from
  /// return: List<Widget>, a list of Rows
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

  /// Returns a contained Stack which displays formatted user profile image,
  /// name, and a background color defined by the top-most container.
  /// 
  /// param user {User}: User to pull information from
  /// param context {BuildContext}: BuildContext from MaterialApp
  /// return: Widget (Container)
  Widget _buildProfileImageStack(User user, BuildContext context) {
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

/// [async]
/// Return a Future<User> from http.get request for
/// user with FutureBuilder
/// 
/// param url {String}: url to make request to
/// return: Future<User>
Future<User> getUserFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DocumentSnapshot document = await Firestore.instance
                                .collection('users').document(prefs.get("UserID")).get();
  User user = User.fromMap(document.data);
  user.getProfilePicUrl.then(
    (param) {
        user.profilePicUrl = param;
    }
  );
  return user;
}

class getClipper extends CustomClipper<Path> {
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

Widget myBox() {
  return Container(
    width:300,
    //margin: const EdgeInsets.all(30.0),
    padding: const EdgeInsets.all(5.0),
    decoration: myBoxDecoration(), //             <--- BoxDecoration here
    child: Text(
      "These are where the notes go.",
      style: TextStyle(fontSize: 14.0),
    ),
  );
}

BoxDecoration myBoxDecoration() { //line underneath the notes
  return BoxDecoration(
    border: Border(
      bottom: BorderSide( //                   <--- left side
        color: Colors.black,
        width: 1.0,
      ),
    ),
  );
}