import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(ProfilePageContainer());

class ProfilePageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: InformationList(),
    );
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
