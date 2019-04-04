import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var url = 'https://next.json-generator.com/api/json/get/EyBSiFo_L';


void main() => runApp(ProfilePageContainer());


Future<User> getUserFromResponse(url) async {
  http.Response resp = await http.get(url);
  var userJson = json.decode(resp.body);
  var user = User.fromJson(userJson[0]);
  return user;
}



class ProfilePageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: null
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
            return Text('Starting connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Loading...');
          case ConnectionState.done:
            if (snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            return Column(
              children: [
                Image.network(snapshot.data.picture),
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, i) {
                    if (i.isOdd) return Divider();
                    // TODO: where does 'i' come from????
                  }

                )
              ],
            );
        }
      });
  }

  Widget _buildListTile(String header, String content) {

  }
}

class User {
  int id;
  String fName;
  String lName;
  String picture;
  String birthday;
  List<String> uploads;
  List<Map> visits;

  User(this.id, this.fName, this.lName, this.picture, this.birthday,
      this.uploads, this.visits);

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      fName = json['name']['first'],
      lName = json['name']['last'],
      picture = json['picture'],
      birthday = json['birthday'],
      uploads = json['uploads'],
      visits = json['visits'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'picture': picture,
        'birthday': birthday,
        'uploads': uploads,
        'name': {'fname': fName, 'lname': lName},
        'visits': visits
      };

  String get name => fName + ' ' + lName;
}
