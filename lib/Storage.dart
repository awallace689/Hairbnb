import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'User.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as HTTP;


class Storage {
  static Future<String> get getDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getFile(String fileName) async {
    final path = await getDirPath;
    File file = File('$fileName');
    print(file.existsSync());
    return file;
  }

  Future<File> saveToFile(String data, String fileName) async {
    final file = await getFile(fileName);
    return file.writeAsString(data);
  }

  Future<String> readFromFile(String fileName) async {
    try {
      File file = await getFile(fileName);
      String fileContents = await file.readAsString();
      return fileContents;
    } catch(e) {
      return "";
    }
  }

  Future<File> _UserToFile(User user, String fileName) async
  {
    File file = await getFile(fileName);
    String data = jsonEncode(user.toJson());
    return file.writeAsString(data);
  }

  File UserToFile(User user, String fileName){
    File NewJSON;
    _UserToFile(user, fileName).then((result) {
      NewJSON = result;
    });
    return NewJSON;
  }

  Future<User> _FileToUser(String fileName) async{
    String data = await readFromFile(fileName);
    Map<String, dynamic> JSON = jsonDecode(data);
    return User.fromJson(JSON);
  }

  User FileToUser(String fileName){
    User NewUser;
    _FileToUser(fileName).then((result) {
      NewUser = result;
    });
    return NewUser;
  }

  Future<List<User>> _HTTPToUserList(String http) async {

  }

  List<User> HTTPToUserList(String http){
    List<User> UserList;
    _HTTPToUserList(http).then((result) {
      UserList = result;
    });
    return UserList;
  }

  Future<User> HTTPToUser(String http) async {
    User user = User("", "", "", "", "", "", [], false);
    HTTP.Response data = await HTTP.get(http);
    String JSON = data.body;
    //user = User.fromJson(jsonDecode(JSON));
    return user;
  }

//  User HTTPToUser(String http){
//    User user;
//    _HTTPToUser(http).then((result) {
//      print(result);
//      user = result;
//    });
//    return user;
//  }

}