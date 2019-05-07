import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

///Intialize a stateful widget
class ContactsPage extends StatefulWidget
{
  ///Constructor that will assist in creating state.
  ContactsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ContactsPageState createState() => _ContactsPageState();
}


///creates class that will retrieve details from json and in return 
///fill a list of customer object with their pertaining values.
class _ContactsPageState extends State<ContactsPage>
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///create list of customer objects that will 
  ///import from async that contains future class
  ///http requests are handled through http package
  ///convert package handles data
  Future<List<Customer>> _fetchCustomers() async {
    _auth.signInAnonymously();
    QuerySnapshot allUsers = await Firestore.instance.collection('users').getDocuments();
    List<Customer> customers = List<Customer>();
    for (var  u in allUsers.documents)
    {
      print(u.data);
      String photoURL = await getPictureURL(u.data['userid']);
      Customer customer = Customer(
          u.data['name']['first'] + " " + u.data['name']['last'],
          u.data['email'],
          photoURL,
          u.data['phoneNumber'],
          u.data['birthday']
       );
      customers.add(customer);

    }
    return customers;
  }

  ///Retrieves the profile picture URL.
  ///
  /// Returns the profile picture url from the
  /// firestore database.
  Future<String> getPictureURL(String userid) async{
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
        .child("/$userid/profilePicture.jpg");
    String profilePicUrl = await firebaseStorageRef.getDownloadURL();
    return profilePicUrl;
  }

  ///In charge of building contact display list
  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Container(
        child: FutureBuilder(
          future: _fetchCustomers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            /// if snapshot data is null than that message will be given

            if(snapshot.data == null)
            {
              return Container(
                  child: Center(
                      child: Text ("loading... ")
                  )
              );
            }
            ///if data is contained within list
            else {

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: CircleAvatar(
                      ///Utilizes network image consturctor and picture data provided by json to insert a circle 
                      ///avatar of user 
                      backgroundImage: NetworkImage(
                          snapshot.data[index].pictureURL
                      ),
                    ),
                    ///Text will be provided within the list showing the name and email of the customer. 
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: () {showDialog(context: context, builder: (BuildContext context) => ContactDialog(snapshot.data[index], context));},
                  );
                },
              );
            }
          },
        ),

      ),
    );
  }
}

///Builds a dialog widget that appears when clicked on.
///
/// The widget contains information about the customer
/// as well as a button to call the customer, and to dismiss the dialog.
Widget ContactDialog(Customer customer, BuildContext context){
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
    content: Column(
      children: <Widget>[
        Container(
            width: 250.0,
            height: 250.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(customer.pictureURL)
                )
            )
        ),
        Text(customer.name, style: TextStyle(fontSize: 25),),
        Text(customer.phoneNum),
        Text(customer.email)
      ],
    ),
    actions: <Widget>[
      FlatButton(
        color: Colors.green,
        child: Text('Call', style: TextStyle(color: Colors.white),),
        onPressed: (){_launchcaller("tel: " + customer.phoneNum);},
      ),
      FlatButton(
        color: Colors.red,
        child: Text('Close', style: TextStyle(color: Colors.white),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

///Launches the phone app to call the customer.
_launchcaller(String phone) {
  launch(phone);
}

///Customer class that intializes that values pertaining to a customer
class Customer{
  final String name;
  final String email;
  final String pictureURL;
  final String phoneNum;
  final String DOB;

///Customer constructor that will be utilized by for loop to loop through json and insert specific 
///details about each customer. 
  Customer(this.name, this.email, this.pictureURL, this.phoneNum, this.DOB);
}
///Class that outlines the on tap functionality. 
class Details extends StatelessWidget{
  final Customer customer;
  Details(this.customer);
  @override
///If user taps on a specific customer contact then the name and email shall be provided. 
  Widget build(BuildContext context)
  {

    return Expanded(
      child: Text(customer.name + "\n " + customer.email),
    );
  }

}