import 'package:flutter/material.dart';

class appointment extends StatefulWidget {
  /// Creates a stateful widget and a stateful element,
  /// and the stateful element will be mounted to the element tree.

  /// Default constructor that takes no parameter.
  appointment();

  @override

  /// Create a stateful obejct that will be mounted in the element tree.
  _appointmentState createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  /// Holds the properties that make of the appointment page,
  /// and trigger the builds the function which returns a ListView
  /// widget.

  /// Holds a list of customer_appointment objects that have dummy properties
  /// for this prototype.
  List<customer_appointment> mycustomer=[customer_appointment("Allen Lu", "icemelon27@gamil.com", "14:30 pm", "Monday",), //"A"),
                                         customer_appointment("Paul Kline", "pkline@ku.edu", "15:30 pm", "Monday",), //"P"),
                                         customer_appointment("Teddy Kahwaji", "Teddykahwaji86@gmail.com", "16:30 pm", "Tuesday",), //"T"),
                                         customer_appointment("Miller Bath", "Miller_bath@gmail.com", "16:50 pm", "Tuesday",), //"M"),
                                         customer_appointment("Alex Wittman", "Alex_Wittman@gmail.com", "17:00 pm", "Tuesday",), //"A"),
                                         customer_appointment("Adam Wallace", "Adam_Wallace@gmail.com", "17:30 pm", "Wednesday",), //"A"),
                                         customer_appointment("Lebron James", "Lebron_James86@gmail.com", "17:40 pm", "Wednesday",),// "L"),
                                         customer_appointment("John Gibbons", "jgibbons@ku.edu", "10:00 am", "Wednesday",),// "J"),
                                         customer_appointment("Gary Minden", "Gminden@ku.edu", "11:30 am", "Wednesday", )];//"G")];

  /// Adds the cusomer_appointment objects as parameter to the list.
  /// Not used by this prototype.
  void add_appointment(customer_appointment customer)
  {
    mycustomer.add(customer);
  }

  /// Remove a specific cusomer_appointment objects from the list
  /// based on the position index as the paramater.
  /// Not used by this prototype.
  void finish_appointment(int index)
  {
    mycustomer.removeAt(index);
  }

  /// Retutrn a GestureDetector widget.
  Widget _listItembuilder(BuildContext context, int index)
  {
    /// GestureDectector widget that takes a ListTile as child, which provide
    /// the functionality for the ListTile to be able to be tapped.
    /// When ListTile is tapped, a dialog will be rendered to the page.
    return GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context, mycustomer[index])),
        child: ListTile(//leading: CircleAvatar(child: Text(mycustomer[index].picURL)),
                        title: Text(mycustomer[index].name),
                        subtitle: Text(("Appoinment time: " + mycustomer[index].time) + " " + mycustomer[index].date))
            );
  }

  /// Returns a SimpleDialog widget.
  Widget _dialogbuilder(BuildContext context, customer_appointment appoint_customer)
  {
    /// SimpleDiaglog widget that takes a list of text widgets as the
    /// children property.
    /// SizeBox widget is to give an vertical distance between two Text widgets.
    return SimpleDialog(children: <Widget>[
    Column(children: <Widget>[Text(appoint_customer.name), Text(appoint_customer.email)]),
    SizedBox(height: 16.0),
     ], contentPadding: EdgeInsets.all(0.0));
  }

  /// Automatically triggered by the stateful obeject when is
  /// being mounted to the element tree.
  /// Returns a ListView widget and display the children widgets
  /// in an organzied way based on the itemCount.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: mycustomer.length, itemBuilder: _listItembuilder);
  }
}


class customer_appointment{
  /// Holds all the properties of an customer_appointment object.

  /// Initialize the properties held by one customer_appointment object.
  customer_appointment(this.name, this.email, this.time, this.date,);//this.picURL);

  /// Name of the customer.
  String name;

  /// Email of the customer.
  String email;

  /// Appoinment time.
  String time;

  /// Appointment date.
  String date;
  //String picURL;
}
