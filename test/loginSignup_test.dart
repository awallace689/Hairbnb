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
}