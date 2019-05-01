// Imports the Flutter Driver API
import 'package:project4/TopSide/LoginSignUp.dart';
import 'package:test/test.dart';

void main() {
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

  test('Given valid DOB, returns true.', () {
    String input = "Valid1";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, true);
  });

  test('Given valid DOB, returns true.', () {
    String input = "Doggo1!";
    var result = LoginSignUpState().isValidPassword(input);
    expect(result, true);
  });
}