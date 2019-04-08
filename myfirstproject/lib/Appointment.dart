import 'package:flutter/material.dart';

class appointment extends StatefulWidget {

  appointment();
  @override
  _appointmentState createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {

  List<customer_appointment> mycustomer=[customer_appointment("Allen Lu", "icemelon27@gamil.com", "14:30 pm", "Monday",), //"A"),
                                         customer_appointment("Paul Kline", "pkline@ku.edu", "15:30 pm", "Monday",), //"P"),
                                         customer_appointment("Teddy Kahwaji", "Teddykahwaji86@gmail.com", "16:30 pm", "Tuesday",), //"T"),
                                         customer_appointment("Miller Bath", "Miller_bath@gmail.com", "16:50 pm", "Tuesday",), //"M"),
                                         customer_appointment("Alex Wittman", "Alex_Wittman@gmail.com", "17:00 pm", "Tuesday",), //"A"),
                                         customer_appointment("Adam Wallace", "Adam_Wallace@gmail.com", "17:30 pm", "Wednesday",), //"A"),
                                         customer_appointment("Lebron James", "Lebron_James86@gmail.com", "17:40 pm", "Wednesday",),// "L"),
                                         customer_appointment("John Gibbons", "jgibbons@ku.edu", "10:00 am", "Wednesday",),// "J"),
                                         customer_appointment("Gary Minden", "Gminden@ku.edu", "11:30 am", "Wednesday", )];//"G")];

  void add_appointment(customer_appointment customer)
  {
    mycustomer.add(customer);
  }

  void finish_appointment(int index)
  {
    mycustomer.removeAt(index);
  }

  Widget _listItembuilder(BuildContext context, int index)
  {
    return GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context, mycustomer[index])),
        child: ListTile(//leading: CircleAvatar(child: Text(mycustomer[index].picURL)),
                        title: Text(mycustomer[index].name),
                        subtitle: Text(("Appoinment time: " + mycustomer[index].time) + " " + mycustomer[index].date))
            );
  }

  Widget _dialogbuilder(BuildContext context, customer_appointment appoint_customer)
  {
    return SimpleDialog(children: <Widget>[
    Column(children: <Widget>[Text(appoint_customer.name), Text(appoint_customer.email)]),
    SizedBox(height: 16.0),
     ], contentPadding: EdgeInsets.all(0.0));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: mycustomer.length, itemBuilder: _listItembuilder);
  }
}


class customer_appointment{
  customer_appointment(this.name, this.email, this.time, this.date,);//this.picURL);

  String name;
  String email;
  String time;
  String date;
  //String picURL;
}