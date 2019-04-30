///Used to store data of the customer.
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//////////////////////////////////////////////////////////////////////////
//                         BEGIN NEW USER CODE
//////////////////////////////////////////////////////////////////////////
class User {
  String email; //Email as plaintext
  Map<String, String> name; //Name as an object containing first and last name.
  String phoneNumber; //Phone as plaintext
  String birthday; //Birthday as MM/DD/YYYY
  List<dynamic> _pastVisits = []; //List of appointment IDs
  String userid;  //Firestore generated ID.
  String profilePicUrl; //URL of profile picture uploaded to firestore.

  /// Create User by passing parameter for each field.
  User(this.email, this.name, this.phoneNumber,
       this.birthday, this._pastVisits, this.userid);

  /// Create User from a Map [Firebase]. Member variables follow DB
  /// naming scheme.
  /// 
  /// This is done using an initializer list (:), which executes before
  /// the constructor runs so you don't have to write 'this'.
  ///         User user =
  ///              User.fromFB(Firebase.reference().query('get user'));
  /// 
  User.fromMap(Map data)
    : email = data['email'],    
      name = {
        'first': data['name']['first'],
        'last': data['name']['last'] 
      },
      phoneNumber = data['phoneNumber'],
      birthday = data['birthday'],
      _pastVisits = data['pastVisits'],
      userid = data['userid'];

  dynamic toJson() =>
    {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
      'pastVisits': visits,
      'userid' : userid
    };

  /// Return Future<String> of profile picture download URL from Firestore.
  /// 
  /// return: Future<String>
  Future<String> get getProfilePicUrl async {
    String userID = this.userid;
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
                                          .child("/$userID/profilePicture.jpg");
    this.profilePicUrl = await firebaseStorageRef.getDownloadURL();
    return profilePicUrl;
  }

  /// Return Future<String> of picture uploaded with appointment at 'index'
  /// 
  /// return: Future<String>
  Future<String> getImageUrlFuture(int index) async {
    String userID = this.userid;
    String appID = this.visits[index]['AppointmentID'];
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
                                           .child("/$userID/$appID.jpg");
    String url = await firebaseStorageRef.getDownloadURL();
    return url;
  }

  List<dynamic> get visits {
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