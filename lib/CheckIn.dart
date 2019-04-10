///Used to store the data for a checkin.
class CheckIn
{
  String email;
  String time;
  String description;

  ///CheckIn constructor to initialize a checkin.
  ///
  ///Places given values in the correct variables.
  CheckIn(String email,
      String time,
      String description)
  {
    this.email = email;
    this.time = time;
    this.description = description;
  }

  ///Converts a CheckIn to a JSON object.
  ///
  ///Returns a JSON object with all the CheckIn values.
  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'time': time,
        'description' : description,
      };

  ///Converts a JSON object to a CheckIn.
  ///
  ///Takes the [parsedJson] and calls the CheckIn
  ///constructor. Returns a new CheckIn.
  factory CheckIn.fromJson(Map<String, dynamic> parsedJson){
    return CheckIn(
        parsedJson['email'],
        parsedJson['time'],
        parsedJson['description']
    );
  }
}