/// Barber class for creating an 'admin'
/// Shows a different version of the application vs a customer login
/// Defines all properties listed below for what constitutes as a 'barber'
class barber
{
  String email;
  String password;
  List<Map<String, String>> appointments;
  List<Map<String, String>> customers;

  barber(this.email, this.password, this.appointments, this.customers);


}

/// Appointment class called when needing to create an appointment by
/// the customer or to be viewed by a barber.
class Appointment
{
  String user_id;
  String date;
  String time;
  String notes;

  Appointment(this.user_id, this.date, this.time, this.notes);

  String getUser_id()
  {
    return user_id;
  }

  String getDate()
  {
    return date;
  }

  String getTime()
  {
    return time;
  }

  String getNotes()
  {
    return notes;
  }

}