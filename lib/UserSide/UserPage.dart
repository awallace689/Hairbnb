import 'package:flutter/material.dart';
import 'Home.dart';
import 'Myshop.dart';
import 'ProfilePage.dart';
import 'CheckInPage.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  final _widgetOptions = [HomePage(), Myshop(), CheckInPage(), ProfilePage()];

  _handleTap(int index) {

    return(_widgetOptions.elementAt(index));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[400],
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(child: _handleTap(_selectedIndex)),
        bottomNavigationBar : BottomNavigationBar(
          type:BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('My shop')),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('Appointment')),
            BottomNavigationBarItem(icon: Icon(Icons.perm_contact_calendar), title: Text('Contacts')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.red,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
