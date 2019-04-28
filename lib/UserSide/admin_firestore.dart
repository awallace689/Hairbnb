class barber
{
  String email;
  String password;
  List<Map<String, String>> appointments;
  List<Map<String, String>> customers;

  barber(this.email, this.password, this.appointments, this.customers);


}

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