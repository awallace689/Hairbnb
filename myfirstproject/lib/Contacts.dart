import 'package:flutter/material.dart';

class contacts extends StatefulWidget {

  contacts();

  @override
  _contactsState createState() => _contactsState();
}

class _contactsState extends State<contacts> {

  List<contact> mycustomer=[contact("Allen Lu", "icemelon27@gamil.com", "14:30 pm", "Monday", "A"),
  contact("Paul Kline", "pkline@ku.edu", "15:30 pm", "Monday", "P"),
  contact("Teddy Kahwaji", "Teddykahwaji86@gmail.com", "16:30 pm", "Tuesday", "T"),
  contact("Miller Bath", "Miller_bath@gmail.com", "16:50 pm", "Tuesday", "M"),
  contact("Alex Wittman", "Alex_Wittman@gmail.com", "17:00 pm", "Tuesday", "A"),
  contact("Adam Wallace", "Adam_Wallace@gmail.com", "17:30 pm", "Wednesday", "A"),
  contact("Lebron James", "Lebron_James86@gmail.com", "17:40 pm", "Wednesday", "L"),
  contact("John Gibbons", "jgibbons@ku.edu", "10:00 am", "Wednesday", "J"),
  contact("Gary Minden", "Gminden@ku.edu", "11:30 am", "Wednesday", "G")];

  void add_contact(contact customer)
  {
    mycustomer.add(customer);
  }

  void remove_contact(int index)
  {
    mycustomer.removeAt(index);
  }

  Widget _listItembuilder(BuildContext context, int index)
  {
    return GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context, mycustomer[index])),
        child: ListTile(leading: CircleAvatar(child: Text(mycustomer[index].picURL)),
            title: Text(mycustomer[index].name),
            subtitle: Text(mycustomer[index].email))
    );
  }

  Widget _dialogbuilder(BuildContext context, contact customer)
  {
    return SimpleDialog(children: <Widget>[
      Column(children: <Widget>[Text(customer.name), Text(customer.email)]),
      SizedBox(height: 16.0),
    ], contentPadding: EdgeInsets.all(0.0));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: mycustomer.length, itemBuilder: _listItembuilder);
  }
}

class contact {

  contact(this.name, this.email, this.time, this.date, this.picURL);

  String name;
  String email;
  String time;
  String date;
  String picURL;
}
