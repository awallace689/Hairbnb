import 'package:flutter/material.dart';
import 'package:project4/UserSide/ProfilePage.dart';
import 'package:test/test.dart';
import 'package:project4/UserSide/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  group("CheckInPage test", () {
    test('User.toJSON has valid output.', () {
      User user = createUser();
      expect(user.toJson(), {
        'email': 'test@email.com',
        'name': {'first': 'first', 'last': 'last'},
        'phoneNumber': '5555555555',
        'birthday': '02/22/90',
        'pastVisits': [],
        'userid': '1234asdf',
      });
    });

    test('User.fromMap has valid output.', () {
      User user = User.fromMap({
        'email': 'test@email.com',
        'name': {'first': 'first', 'last': 'last'},
        'phoneNumber': '5555555555',
        'birthday': '02/22/90',
        '_pastVisits': [],
        'userid': '1234asdf',
        'profilePicUrl': 'myurl.com'
      });
      expect([user.email, user.name, user.phoneNumber, user.birthday, user.visits, user.userid],
      ['test@email.com', {'first': 'first', 'last': 'last'}, '5555555555', '02/22/90', [], '1234asdf']);
    });
  });
}

User createUser() {
  return User.fromMap({
    'email': 'test@email.com',
    'name': {'first': 'first', 'last': 'last'},
    'phoneNumber': '5555555555',
    'birthday': '02/22/90',
    '_pastVisits': [],
    'userid': '1234asdf',
    'profilePicUrl': 'myurl.com'
  });
}
