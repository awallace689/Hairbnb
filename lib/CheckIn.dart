class CheckIn
{
  String email;
  String time;
  String description;

  CheckIn(String email,
      String time,
      String description)
  {
    this.email = email;
    this.time = time;
    this.description = description;
  }

  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'time': time,
        'description' : description,
      };

  Map<String, String> toJsonForPost() =>
      {
        'email': email,
        'time': time,
        'description' : description,
      };

  factory CheckIn.fromJson(Map<String, dynamic> parsedJson){
    return CheckIn(
        parsedJson['email'],
        parsedJson['time'],
        parsedJson['description']
    );
  }
}