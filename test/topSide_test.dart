// Imports the Flutter Driver API
import 'package:project4/TopSide/LoginSignUp.dart';
import 'package:test/test.dart';

void main() {
  //emails
  test('Given invalid email, returns false.', () {
    String input = "notValid";
    var result = LoginSignUpState().isValidEmail(input);
    expect(result, false);
  });

  test('Given valid email, returns true.', () {
    String input = "valid@gmail.com";
    var result = LoginSignUpState().isValidEmail(input);
    expect(result, true);
  });

  //passwords
  test('Given invalid password, returns false.', () {
    String input = "notValid";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, false);
  });

  test('Given invalid password, returns false.', () {
    String input = "notVlidddddd";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, false);
  });

  test('Given invalid password, returns false.', () {
    String input = "thisis!not valid";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, false);
  });

  test('Given valid password, returns true.', () {
    String input = "Valid1";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, true);
  });

  test('Given valid password, returns true.', () {
    String input = "Doggo1!";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, true);
  });

  //phone numbers
  test('Given valid phone number, returns false.', () {
    String input = "55565465";
    var result = LoginSignUpState().isValidPhone(input);
    expect(result, false);
  });

  test('Given valid phone number, returns false.', () {
    String input = "f23k5ksi59";
    var result = LoginSignUpState().isValidPhone(input);
    expect(result, false);
  });

  test('Given valid phone number, returns true.', () {
    String input = "1235986789";
    var result = LoginSignUpState().isValidPhone(input);
    expect(result, true);
  });

  //DOB
  test('Given valid DOB, returns false.', () {
    String input = "";
    var result = LoginSignUpState().isValidDOB(input);
    expect(result, false);
  });

  test('Given valid DOB, returns false.', () {
    String input = "11/654/65498498";
    var result = LoginSignUpState().isValidDOB(input);
    expect(result, false);
  });

  test('Given valid DOB, returns true.', () {
    String input = "1/1/2001";
    var result = LoginSignUpState().isValidDOB(input);
    expect(result, true);
  });


}