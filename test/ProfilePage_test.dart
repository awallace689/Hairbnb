// Imports the Flutter Driver API
import 'package:project4/UserSide/ProfilePage.dart';
import 'package:test/test.dart';

void main() {
  test('Comparing appointments a, b, where a is before b returns 1', () {
    dynamic a = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    dynamic b = CreateAppointment(DateTime(2001).toIso8601String(), "12:40 PM");
    var result = ProfilePageState().CompareAppointments(a, b);
    expect(result, 1);
  }
  );

  test('Comparing appointments a, b, where a is after b returns -1', () {
    dynamic a = CreateAppointment(DateTime(2001).toIso8601String(), "12:40 PM");
    dynamic b = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    var result = ProfilePageState().CompareAppointments(a, b);
    expect(result, -1);
  }
  );

  test('Comparing appointments a, b, where a.date is same as b.date, but a.time is before b.time returns 1', () {
    dynamic a = CreateAppointment(DateTime(2000).toIso8601String(), "12:30 PM");
    dynamic b = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    var result = ProfilePageState().CompareAppointments(a, b);
    expect(result, 1);
  }
  );

  test('Comparing appointments a, b, where a.date is same as b.date, but a.time is after b.time returns -1', () {
    dynamic a = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    dynamic b = CreateAppointment(DateTime(2000).toIso8601String(), "12:30 PM");
    var result = ProfilePageState().CompareAppointments(a, b);
    expect(result, -1);
  }
  );

  test('Comparing appointments a, b, where a and b have same date and time returns -1', () {
    dynamic a = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    dynamic b = CreateAppointment(DateTime(2000).toIso8601String(), "12:40 PM");
    var result = ProfilePageState().CompareAppointments(a, b);
    expect(result, -1);
  }
  );
}

dynamic CreateAppointment(String date, String time){
  return {
    'Time' : {
      'Date' : date,
      'Time' : time
    }
  };
}