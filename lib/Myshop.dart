import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
class Myshop extends StatelessWidget {

  Myshop();

  _launchcaller()
  {
      var url = 'tel:+1 785 749 4517';

      launch(url);

  }

  _lanuchfacebook()
  {
    var url = 'https://www.facebook.com/amyxnorth/';

    launch(url);

  }

  _lanuchinstagram()
  {
    var url = 'https://www.instagram.com/amyxbarbershopnorth/?hl=en';

    launch(url);

  }

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
