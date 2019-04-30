import 'package:flutter/material.dart';
import 'package:project4/UserSide/ProfilePage.dart';
import 'package:test/test.dart';
import 'package:project4/UserSide/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  group("CheckInPage test", ()
  {
    test('User.toJSON has valid output.', () {
      User user = createUser();
      expect(user.toJson(), {
        'email': 'test@email.com',
        'name': {'first':'first', 'last':'last'},
        'phoneNumber': '5555555555',
        'birthday': '02/22/90',
        'pastVisits': [],
        'userid': '1234asdf',
      });
    });

    test('Can update and read users from Firestore.', () {
      Firestore.instance
        .collection("users")
        .document('unit_test_dont_delete')
        .get().then( (DocumentSnapshot ds) {
          // expect(ds.data, {
          //   'email': 'test@email.com',
          //   'name': {'first':'first', 'last':'last'},
          //   'phoneNumber': '5555555555',
          //   'birthday': '02/22/90',
          //   '_pastVisits': [],
          //   'userid': '1234asdf',
          //   'profilePicUrl': 'myurl.com'
          // });
          int pNum = ds.data['phoneNumber'].parse();
          User user = User.fromMap(ds.data);
          pNum++;
          user.phoneNumber = pNum.toString();


        });
    });

    
  });
}

User createUser() {
  return User.fromMap({
    'email': 'test@email.com',
    'name': {'first':'first', 'last':'last'},
    'phoneNumber': '5555555555',
    'birthday': '02/22/90',
    '_pastVisits': [],
    'userid': '1234asdf',
    'profilePicUrl': 'myurl.com'
  });
}