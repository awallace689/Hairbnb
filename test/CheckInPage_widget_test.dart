import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project4/UserSide/CheckInPage.dart';
import 'package:mockito/mockito.dart';




void main()
{
  Widget makeTestableWidget({Widget child})
  {
    return MaterialApp(
      home:child,
    );


  }


  testWidgets('Correctly rendering the initial check in page', (WidgetTester tester) async {

    bool initial = false;

    CheckInPage page = CheckInPage(testing: () => initial = true);

    await tester.pumpWidget(makeTestableWidget(child: page));

    expect(initial, false);

  });

//  testWidgets('Correctly rendering the check in form when button being clicked', (WidgetTester tester) async {
//
//    bool initial = false;
//
//    CheckInPage page = CheckInPage(testing: () => initial = true);
//
//    await tester.pumpWidget(makeTestableWidget(child: page));
//
//    await  tester.tap(find.byKey(Key('CheckIn')));
//    await  tester.pump();
//
//    expect(find.text('Check in'), findsOneWidget);
//
//  });
//
//  testWidgets('Empty field can not be submitted', (WidgetTester tester) async {
//
//    bool initial = false;
//
//    CheckInPage page = CheckInPage(testing: () => initial = true);
//
//    await tester.pumpWidget(makeTestableWidget(child: page));
//
//    await  tester.tap(find.byKey(Key('CheckIn')));
//    await  tester.pump();
//    await  tester.tap(find.byKey(Key('submit')));
//    await  tester.pump();
//
//    expect(find.text('You must add a photo.'), findsOneWidget);
//
//  });

}