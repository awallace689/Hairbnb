import 'package:flutter/material.dart';
import 'package:project4/UserSide/CheckInPage.dart';
import 'package:test/test.dart';


void main(){

  group("CheckInPage test", ()
  {
    test('Empty description returns null', () {
      var result = DescriptionValidator.validate(null);
      expect(result, "Description can not be empty!");
    });

    test("Non-empty description returns the string itself", () {
      var result = DescriptionValidator.validate("Just test");
      expect(result, "Just test");
    });

    test("Empty date returns designed error message", (){
      DateTime test_date;
      var result = DateValidator.validate(test_date);
      expect(result, "Please select a date!");
    });

    test("Non-empty date returns null", (){
      DateTime test_date= DateTime.now();
      var result = DateValidator.validate(test_date);
      expect(result, null);
    });

    test("Empty time returns designed error message", (){
      TimeOfDay test_time;
      var result = TimeValidator.validate(test_time);
      expect(result, "Please select a time!");
    });

    test("Non-empty time returns null", (){
      TimeOfDay test_time = TimeOfDay.now();
      var result = TimeValidator.validate(test_time);
      expect(result, null);
    });

  });
}