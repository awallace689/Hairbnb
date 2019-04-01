import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:http/http.dart' as http;
import 'dart:convert'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
 {
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Customers ',
      theme: ThemeData(
        primarySwatch:  Colors.blue,
     ),
      home: MyHomePage(title: 'Customers'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title; 
  @override
  _MyHomePageState createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> 
{
  //imported from async that contains future class
  //http requests are handled through ttp package 
  //convert package handles data
  Future<List<Customer>> _fetchCustomers() async {
    //http://www.json-generator.com/api/json/get/cqNeclUegi?indent=2
   var data = await http.get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");
   //convert to json package
   var myJson = json.decode(data.body); 

    //intialize an empty list of customers
   List<Customer> customers = []; 

   //loop through json object and populate user list. 
   for (var  u in myJson)
   {
     Customer customer = Customer(u["index"],u["name"], u["picture"], u["haircutDetails"],u["age"],u["phone"],u["email"]); 
     customers.add(customer); 


   }

   print(customers.length);
   return customers; 
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), 
      ),
      body: Container(
        child: FutureBuilder( 
          future: _fetchCustomers(), 
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if snapshot data is null than that message will be given
      
            if(snapshot.data == null)
            {
              return Container( 
                child: Center( 
                  child: Text ("loading... ")
                )
              );
            }else {
            
            return ListView.builder( 
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].picture
                        ),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].email),
                      onTap:(){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context)=>Details(snapshot.data[index]))
                        );
                      },
                      
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


class Customer{
  final int index; 
 // final String about; 
  final String haircutDetails ; 
  final String name; 
  final String email; 
  final String picture; 
  final int phoneNum; 
  final int age; 
   
  Customer(this.index, this.name, this.picture, this.haircutDetails,this.age, this.phoneNum,this.email);
  
}

class Details extends StatelessWidget{
  final Customer customer; 
Details(this.customer); 
@override

  Widget build(BuildContext context)
  {
    return Scaffold( 
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: Text(customer.email) 

      
     
    );
  }

}