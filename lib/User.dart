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

  static User fromJson(Map<String, dynamic> parsedJson) =>
      new User(
      parsedJson['email'],
      parsedJson['password'],
      parsedJson['firstName'],
      parsedJson['lastName'],
      parsedJson['phone'],
      parsedJson['image'],
      parsedJson['pastVisits'],
      parsedJson['isAdmin']
    );

  void printUser() {
    print(this.email);
    print(this.password);
    print(this.firstName);
    print(this.lastName);
    print(this.phone);
    print(this.image);
    print(this.pastVisits[0]);
    print(this.isAdmin);
  }
}