// Imports the Flutter Driver API
import 'package:project4/TopSide/LoginSignUp.dart';
import 'package:test/test.dart';

void main() {
  test('Date of birth returns empty string or error', () {
    string input = "";
    var result = LoginSignUpState().convertToDate(input);
    expect(result, "");
  }

  );
}