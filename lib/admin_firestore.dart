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
  String date_time;
  List<String> appointment_images;
  String notes;

  Appointment(this.user_id, this.date_time, this.appointment_images, this.notes);
}