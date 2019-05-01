import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:project4/UserSide/UserPage.dart';



void main() {


  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

//  testWidgets('Checking if Appointment tab works properly', (WidgetTester tester) async {
//
//
//    UserPage page = UserPage();
//
//    await tester.pumpWidget(makeTestableWidget(child: page));
//
//    await tester.tap(find.byIcon(Icons.calendar_today));
//    await tester.pump();
//
//    expect(find.text('Check in'), findsOneWidget);
//
//  });

  testWidgets('Checking if My Shop tab works properly', (WidgetTester tester) async {

    provideMockedNetworkImages( () async {

      UserPage page = UserPage();

      await tester.pumpWidget(makeTestableWidget(child: page));

      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();

      expect(find.text('Amyx Barber Shop North'), findsOneWidget);


    });
  });


}
