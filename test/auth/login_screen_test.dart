import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/auth/login_screen.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:darth_runner/widgets/textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helper_mocks.dart';
import '../mocks.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group(
    'LoginScreen Widget Test',
    () {
      late AuthService authService;
      late MockFirebaseAuth mockFirebaseAuth;
      late MockFirebaseFirestore mockFirestore;

      setUp(() {

        mockFirebaseAuth = MockFirebaseAuth();
        mockFirestore = MockFirebaseFirestore();
        authService =
            AuthService(auth: mockFirebaseAuth, firestore: mockFirestore);
      });

      testWidgets('Login screen has email, password, and login button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(auth: authService),
          ),
        );

        expect(find.byType(CustomTextField), findsNWidgets(2));
        expect(find.widgetWithText(CustomTextField, 'Enter Email'),
            findsOneWidget);
        expect(find.widgetWithText(CustomTextField, 'Enter Password'),
            findsOneWidget);

        expect(find.byType(CustomButton), findsOneWidget);
        expect(find.widgetWithText(CustomButton, 'Login'), findsOneWidget);
      });

      testWidgets('Login button triggers login process',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(auth: authService),
          ),
        );

        await tester.enterText(
            find.widgetWithText(CustomTextField, 'Enter Email'),
            'test@example.com');
        await tester.enterText(
            find.widgetWithText(CustomTextField, 'Enter Password'),
            'password123');

        await tester.tap(find.widgetWithText(CustomButton, 'Login'));
        await tester.pumpAndSettle();

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);
        // verify(authService.loginUserWithEmailAndPassword(
        //         'test@example.com', 'password123'))
        //     .called(1);
        // Verify that the login method is called with the correct arguments
        //verify(mockAuthService.loginUserWithEmailAndPassword('test@example.com', 'password123')).called(1);
      });

      testWidgets('Shows error message when login fails',
          (WidgetTester tester) async {
        when(authService.loginUserWithEmailAndPassword('test@example.com', 'password123'))
            .thenThrow(Exception('Invalid credentials'));

        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(auth: authService),
          ),
        );

        await tester.enterText(
            find.widgetWithText(CustomTextField, 'Enter Email'),
            'test@example.com');
        await tester.enterText(
            find.widgetWithText(CustomTextField, 'Enter Password'),
            'password123');

        await tester.tap(find.widgetWithText(CustomButton, 'Login'));
        await tester.pump();

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);

        expect(find.text('Please enter valid credentials'), findsOneWidget);
      });
    },
  );
}
