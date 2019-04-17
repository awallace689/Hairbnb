///Used to store data of the customer.
class User
{
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  String image;
  List<dynamic> pastVisits;
  bool isAdmin;

  ///User constructor to initialize a user.
  ///
  ///Places given values in the correct variables.
  User(String email,
       String password,
       String firstName,
       String lastName,
       String phone,
       String image,
       List<dynamic> pastVisits,
       bool isAdmin)
  {
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
    this.phone = phone;
    this.image = image;
    this.pastVisits = pastVisits;
    this.isAdmin = isAdmin;
  }

  ///Converts a User to a JSON object.
  ///
  ///Returns a JSON object with all the User values.
  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'image': image,
        'pastVisits': pastVisits,
      };

  ///Converts a JSON object to a User.
  ///
  ///Takes the [parsedJson] and calls the User
  ///constructor. Returns a new User.
  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
        parsedJson['email'],
        parsedJson['password'],
        parsedJson['firstName'],
        parsedJson['lastName'],
        parsedJson['phone'],
        parsedJson['image'],
        parsedJson['pastVisits'],
        parsedJson['isAdmin']
    );
  }
}