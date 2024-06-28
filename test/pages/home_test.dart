import 'package:darth_runner/bmi/bmi_home_screen.dart';
import 'package:darth_runner/pages/home.dart';
import 'package:darth_runner/social/community_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helper_mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('HomePage Widget Tests', () {
    testWidgets('HomePage has app bar, buttons and texts', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomePage(),
      ));

      expect(find.text('Welcome Home'), findsOneWidget);
      expect(find.text('BMI Calculator'), findsOneWidget);
      expect(find.text('Communities'), findsOneWidget);
      expect(find.byType(GestureDetector), findsExactly(2));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  testWidgets('Tapping on BMI Calculator button navigates to BMI home screen',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));
    await tester.tap(find.text('BMI Calculator'));
    await tester.pumpAndSettle();
    expect(find.byType(BMIHomeScreen), findsOneWidget);
  });

  testWidgets('Tapping on Communities button navigates to BMI home screen',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.tap(find.text('Communities'));
    await tester.pumpAndSettle();

    expect(find.byType(CommunityHome), findsOneWidget);
  });
}
