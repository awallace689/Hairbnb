import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';

class Myshop extends StatefulWidget {
  /// Creates a stateful widget and a stateful element,
  /// and the stateful element will be mounted to the element tree.

  @override
  State<StatefulWidget> createState() => _MyshopState();
}

class _MyshopState extends State<Myshop> {
  _launchcaller() {
    var url = 'tel:+1 785 749 4517';

    launch(url);
  }

  /// Launches the default web browswer to visit the barbershop's
  /// facebook page on the user's smart phone.
  _lanuchfacebook() {
    var url = 'https://www.facebook.com/amyxnorth/';

    launch(url);
  }

  /// Launches the default web browswer to visit the barbershop's
  /// instagram page on the user's smart phone.
  _lanuchinstagram() {
    var url = 'https://www.instagram.com/amyxbarbershopnorth/?hl=en';

    launch(url);
  }

  /// Return a dialog widget with the barbershop's phone number in
  /// the dialog and two buttons that give the user option that
  /// wheteher to cancel or to dial the phone number.
  /// When the Call button is tapped, _launchcaller will be called.
  Widget _dialogbuilder(BuildContext context) {
    return SimpleDialog(children: <Widget>[
      SizedBox(height: 13.0),
      Text("+1 (785) 749-4517",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
      SizedBox(height: 13.0),
      Row(
        children: <Widget>[
          SizedBox(
              width: 140,
              child: RaisedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                  color: Colors.white,
                  textColor: Colors.blue)),
          SizedBox(
              width: 140,
              child: RaisedButton(
                  onPressed: _launchcaller,
                  child: const Text("Call"),
                  color: Colors.white,
                  textColor: Colors.blue))
        ],
      )
    ], contentPadding: EdgeInsets.all(0.0));
  }

  /// Automatically triggered by the stateful obeject when is
  /// being mounted to the element tree.
  /// Returns an Container widget that takes an ListView widget as child, and
  /// the ListView widget takes list of widgets as children, those widgets
  /// are mainly Text widgets.
  /// GestureDectector widget makes the phone number which is text tappable.
  @override
  Widget build(BuildContext context) {
    TextStyle title = TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal);
    TextStyle header = TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal);
    TextStyle headerBold =
        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
    TextStyle detail = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400);
    return ListView(children: <Widget>[
      Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://fastly.4sqi.net/img/general/600x600/790765_pGmlPfzRmKiqZv0erX_CnueWVY9koGaZJR0YVThBI4I.jpg"),
                    fit: BoxFit.fitWidth
                ),
          )),
      Card(
          child: Container(
              padding: EdgeInsets.all(12),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Amyx Barber Shop North', style: title),
                  ],
                ),
                Divider(color: Colors.black),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(8), child: Icon(Icons.phone)),
                    GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => _dialogbuilder(context)),
                        child: Text("(785) 749-4517",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline)))
                  ],
                ),
                Divider(color: Colors.black),
                Row(
                  children: <Widget>[Text("Hours: ", style: header)],
                ),
                Row(
                  children: <Widget>[Text('             Mon: 9am-5pm')],
                ),
                Row(
                  children: <Widget>[
                    Text('             Tue: 8am–7pm', style: detail),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('             Wed: 8am–7pm', style: detail),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('             Thurs: 8am–7pm', style: detail),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('             Fri: 8am–7pm', style: detail),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('             Sat: 8am–6pm,', style: detail),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('             Sun: 11am–3pm', style: detail),
                  ],
                ),
                Divider(color: Colors.black),
                Row(
                  children: <Widget>[Text("Address: ", style: header)],
                ),
                Row(
                  children: <Widget>[
                    Text("                 842 Massachusetts St,",
                        style: detail)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "                 Lawrence, KS",
                      style: detail,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '                 66044',
                      style: detail,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
                Row(
                  children: <Widget>[Text("Social Media:", style: header)],
                ),
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: _lanuchfacebook,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://thebottomline.as.ucsb.edu/wp-content/uploads/2016/03/Facebook_wikimediaWEB-696x696.jpg'),
                              radius: 40.0,
                            )),
                        Text('Facebook', style: detail)
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: _lanuchfacebook,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://instagram-brand.com/wp-content/uploads/2016/11/Instagram_AppIcon_Aug2017.png?w=300'),
                              radius: 40.0,
                            )),
                        Text('Instagram', style: detail)
                      ],
                    ),
                  ),
                ])
              ]))),
    ]);

    // return ListView(
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.all(20.0),
    //   children: <Widget>[
    //     SizedBox(height: 30.0),
    //     Text('Amyx Barber Shop North', style: Theme.of(context).textTheme.headline),
    //     SizedBox(height: 16.0),
    //     GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context)),
    //         child:Text("(785) 749-4517", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, decoration: TextDecoration.underline))),
    //     SizedBox(height: 16.0),
    //     Text('Hours: Monday 9AM–5PM', style: Theme.of(context).textTheme.headline),
    //     Text('             Tuesday-Friday 8AM–7PM', style: Theme.of(context).textTheme.headline),
    //     Text('             Sat 8AM–6PM,', style: Theme.of(context).textTheme.headline),
    //     Text('             Sun 11AM–3PM', style: Theme.of(context).textTheme.headline),
    //     SizedBox(height: 16.0),
    //     Text('Address: 842 Massachusetts St,', style: Theme.of(context).textTheme.headline),
    //     Text('                 Lawrence, KS', style: Theme.of(context).textTheme.headline),
    //     Text('                 66044', style: Theme.of(context).textTheme.headline),
    //     SizedBox(height: 16.0),

    //     ///Displays facebook and instagram icons images in a row.
    //     Row(children: <Widget>[GestureDetector(onTap: _lanuchfacebook,
    //                                            child: CircleAvatar(backgroundImage: NetworkImage('https://thebottomline.as.ucsb.edu/wp-content/uploads/2016/03/Facebook_wikimediaWEB-696x696.jpg'), radius: 40.0,)),
    //                            SizedBox(width: 13.0),
    //                            GestureDetector(onTap: _lanuchinstagram,
    //                                            child: CircleAvatar(backgroundImage: NetworkImage('https://instagram-brand.com/wp-content/uploads/2016/11/Instagram_AppIcon_Aug2017.png?w=300'), radius: 40.0,))
    //                            ])
    //   ],
    // );
  }
}
