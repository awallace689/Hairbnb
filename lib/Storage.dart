import 'User.dart';
import 'dart:async';
import 'dart:convert';
import 'CheckIn.dart';
import 'package:http/http.dart' as HTTP;

///Storage handles reading JSON objects from a url.
class Storage {

  ///Converts a JSON object into a list of Users.
  ///
  ///Fetches data from [http] address and converts to to parsable JSON.
  ///Then, converts the JSON into a list of Users.
  Future<List<User>> HTTPToUserList(String http) async {
    List<User> userList = new List();
    HTTP.Response data = await HTTP.get(http);
    String text = data.body;
    for(int i = 0; i < jsonDecode(text).length; i++){
      userList.add(User.fromJson(jsonDecode(text)[i]));
    }
    return userList;
  }

  ///Converts a JSON object into a list of CheckIns.
  ///
  ///Fetches data from [http] address and converts to to parsable JSON.
  ///Then, converts the JSON into a list of CheckIns.
  Future<List<CheckIn>> HTTPToCheckInList(String http) async{
    List<CheckIn> checkInList = new List();
    HTTP.Response data = await HTTP.get(http);
    String text = data.body;
    for(int i = 0; i < jsonDecode(text).length; i++){
      checkInList.add(CheckIn.fromJson(jsonDecode(text)[i]));
    }
    return checkInList;
  }

  ///Converts a JSON object into a User.
  ///
  ///Fetches data from [http] address and converts to to parsable JSON.
  ///Then, converts the JSON into a User.
  Future<User> HTTPToUser(String http) async {
    User user = User("", "", "", "", "", "", [], false);
    HTTP.Response data = await HTTP.get(http);
    String JSON = data.body;
    user = User.fromJson(jsonDecode(JSON));
    return user;
  }
}