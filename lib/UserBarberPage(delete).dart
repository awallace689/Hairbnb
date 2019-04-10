import 'package:flutter/material.dart';
import 'Storage.dart';
import 'Barber(delete).dart';
import 'package:url_launcher/url_launcher.dart' as URL;

class UserBarberPage extends StatefulWidget {
  final Storage storage;

  UserBarberPage({Key key, @required this.storage}) : super(key: key);

  UserBarberPageState createState() => UserBarberPageState();
}

class UserBarberPageState extends State<UserBarberPage> {
  Barber barber;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: GetBarber(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              barber = snapshot.data;
              print(barber);
              return Column(
                children: <Widget>[
                  Text(barber.name),
                  Text(barber.phone),
                  Text(barber.hours),
                  Text(barber.location),
                  RaisedButton(
                    child: Text("Facebook"),
                    onPressed: () {URL.launch(barber.facebook);},
                  ),
                  RaisedButton(
                    child: Text("Instagram"),
                    onPressed: () {URL.launch(barber.instagram);},
                  ),
                  RaisedButton(
                    child: Text("Website"),
                    onPressed: () {URL.launch(barber.website);},
                  ),
                ],
              );
            } else {
              return new CircularProgressIndicator();
            }
          }
          else {
            return new CircularProgressIndicator();
          }
        },
      )
    );
  }

  Future<Barber> GetBarber() async
  {
    //Barber barber = await widget.storage.HTTPToBarber("http://www.json-generator.com/api/json/get/ceGSqdIiDC?indent=2");
    return barber;
  }
}