import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var url = 'https://next.json-generator.com/api/json/get/EyBSiFo_L';


void main() => runApp(MyApp());


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
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DisplayColumn()
    );
  }
}

class DisplayColumn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisplayColumnState();
}

class _DisplayColumnState extends State<DisplayColumn> {
  @override
  Widget build(BuildContext context) {
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
            else if (snapshot.data == null) {
              return Text('Loading...');
            }
            else {
              // Use snapshot data to populate user profile display
              return Container( 
                child: Column(
                  children: [
                    Image.network(snapshot.data.picture),
                    // ListView.builder(
                    //   padding: const EdgeInsets.all(16.0),
                    //   itemBuilder: (context, i) {
                    //     if (i.isOdd) return Divider();
                    //     // TODO: where does 'i' come from????
                    //   }

                    // )
                  ],
              )
            );
          }
        }
      });
  }

//   Widget _buildListTile(String header, String content) {

//   }
}

class User {
  int id;
  String fName;
  String lName;
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
      picture = json['picture'],
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
