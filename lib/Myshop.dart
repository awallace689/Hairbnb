import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
class Myshop extends StatelessWidget {
  /// Creates a stateful widget and a stateful element,
  /// and the stateful element will be mounted to the element tree.

  /// Default constructor that takes no parameter.
  Myshop();

  /// Launches an phone call to the barbershop on the user's smart phone.
  _launchcaller()
  {
      var url = 'tel:+1 785 749 4517';

      launch(url);

  }

  /// Launches the default web browswer to visit the barbershop's
  /// facebook page on the user's smart phone.
  _lanuchfacebook()
  {
    var url = 'https://www.facebook.com/amyxnorth/';

    launch(url);

  }

  /// Launches the default web browswer to visit the barbershop's
  /// instagram page on the user's smart phone.
  _lanuchinstagram()
  {
    var url = 'https://www.instagram.com/amyxbarbershopnorth/?hl=en';

    launch(url);

  }

  /// Return a dialog widget with the barbershop's phone number in
  /// the dialog and two buttons that give the user option that
  /// wheteher to cancel or to dial the phone number.
  /// When the Call button is tapped, _launchcaller will be called.
  Widget _dialogbuilder(BuildContext context)
  {
    return SimpleDialog(children: <Widget>[SizedBox(height: 13.0),
      Text("+1 (785) 749-4517", textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
    SizedBox(height: 13.0),
    Row(children: <Widget>[SizedBox(width: 140, child: RaisedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel"), color: Colors.white, textColor: Colors.blue)),
                           SizedBox(width: 140, child: RaisedButton(onPressed: _launchcaller, child: const Text("Call"), color: Colors.white, textColor: Colors.blue))],
                            )],
      contentPadding: EdgeInsets.all(0.0));
  }


  /// Automatically triggered by the stateful obeject when is
  /// being mounted to the element tree.
  /// Returns an Container widget that takes an ListView widget as child, and
  /// the ListView widget takes list of widgets as children, those widgets
  /// are mainly Text widgets.
  /// GestureDectector widget makes the phone number which is text tappable.
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child:ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        SizedBox(height: 30.0),
        Text('Amyx Barber Shop North', style: Theme.of(context).textTheme.headline),
        SizedBox(height: 16.0),
        GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context)),
            child:Text("(785) 749-4517", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, decoration: TextDecoration.underline))),
        SizedBox(height: 16.0),
        Text('Hours: Monday 9AM–5PM', style: Theme.of(context).textTheme.headline),
        Text('             Tuesday-Friday 8AM–7PM', style: Theme.of(context).textTheme.headline),
        Text('             Sat 8AM–6PM,', style: Theme.of(context).textTheme.headline),
        Text('             Sun 11AM–3PM', style: Theme.of(context).textTheme.headline),
        SizedBox(height: 16.0),
        Text('Address: 842 Massachusetts St,', style: Theme.of(context).textTheme.headline),
        Text('                 Lawrence, KS', style: Theme.of(context).textTheme.headline),
        Text('                 66044', style: Theme.of(context).textTheme.headline),
        SizedBox(height: 16.0),

        ///Displays facebook and instagram icons images in a row.
        Row(children: <Widget>[GestureDetector(onTap: _lanuchfacebook,
                                               child: CircleAvatar(backgroundImage: NetworkImage('https://thebottomline.as.ucsb.edu/wp-content/uploads/2016/03/Facebook_wikimediaWEB-696x696.jpg'), radius: 40.0,)),
                               SizedBox(width: 13.0),
                               GestureDetector(onTap: _lanuchinstagram,
                                               child: CircleAvatar(backgroundImage: NetworkImage('https://instagram-brand.com/wp-content/uploads/2016/11/Instagram_AppIcon_Aug2017.png?w=300'), radius: 40.0,))
                               ])
      ],
    ),
    );
  }
}
