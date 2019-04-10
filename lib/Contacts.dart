import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ContactsPage extends StatefulWidget
{
  ContactsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ContactsPageState createState() => _ContactsPageState();
}


///creates class that will retrieve details from json and in return 
//fill a list of customer object with their pertaining values. 
class _ContactsPageState extends State<ContactsPage>
{
  ///create list of customer objects that will 
  ///import from async that contains future class
  ///http requests are handled through http package
  ///convert package handles data
  Future<List<Customer>> _fetchCustomers() async {
   ///retrieve data through json generator provided by http.get request 
    var data = await http.get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");
    ///convert to json package
    var myJson = json.decode(data.body);

    ///intialize an empty list of customers
    List<Customer> customers = [];

    ///loop through json object and populate user list.
    for (var  u in myJson)
    {
      Customer customer = Customer(u["index"],u["name"], u["picture"], u["haircutDetails"],u["age"],u["phone"],u["email"]);
      customers.add(customer);


    }

    return customers;
  }
  @override
  ///In charge of building contact display list 
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
                          snapshot.data[index].picture
                      ),
                    ),
                    ///Text will be provided within the list showing the name and email of the customer. 
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
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

///Customer class that intializes that values pertaining to a customer
class Customer{
  final int index;
  // final String about;
  final String haircutDetails ;
  final String name;
  final String email;
  final String picture;
  final int phoneNum;
  final int age;
///Customer constructor that will be utilized by for loop to loop through json and insert specific 
///details about each customer. 
  Customer(this.index, this.name, this.picture, this.haircutDetails,this.age, this.phoneNum,this.email);

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