///Used to store data of the customer.
import 'package:firebase_storage/firebase_storage.dart';

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
//////////////////////////////////////////////////////////////////////////
//                         BEGIN NEW USER CODE
//////////////////////////////////////////////////////////////////////////
class FBUser {  // 'User' was already taken
  String email;
  String password;
  Map<String, String> name;
  String phoneNumber;
  String birthday;
  List<Map<String, String>> _pastVisits;
  List<dynamic> uploads;
  String userid;
  String profilePicUrl;

  /// Create FBUser by passing parameter for each field.
  FBUser(this.email, this.password, this.name, this.phoneNumber,
       this.birthday, this._pastVisits, this.uploads, this.userid);

  /// Create FBUser from a Map [Firebase]. Member variables follow DB
  /// naming scheme.
  /// 
  /// This is done using an initializer list (:), which executes before
  /// the constructor runs so you don't have to write 'this'.
  ///         FBUser user = 
  ///              FBUser.fromFB(Firebase.reference().query('get user'));
  /// 
  FBUser.fromFB(Map data)
    : email = data['email'],    
      password = data['password'],
      name = {
        'first': data['name']['first'],
        'last': data['name']['last'] 
      },
      phoneNumber = data['phoneNumber'],
      birthday = data['birthday'],
      _pastVisits = data['pastVisits'],
      uploads = data['uploads'],
      userid = data['userid'];

  dynamic toJson() =>
    {
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
      'pastVisits': _pastVisits,
      'uploads' : uploads,
      'userid' : userid
    };

  Future<String> get getProfilePicUrl async {
    String userID = this.userid;
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
                                          .child("/$userID/profilePicture.jpg");
    this.profilePicUrl = await firebaseStorageRef.getDownloadURL();
    return profilePicUrl;
  }

  List<Map<String, String>> get visits {
    if (this._pastVisits != null){
      return _pastVisits;
    }
    else {
      return <Map<String, String>>[];
    }
  }

  set visits (data) {
    this._pastVisits = data;
  }
}