import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:darth_runner/auth/auth_service.dart';
import '../mocks.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthService authService;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    authService = AuthService(auth: mockFirebaseAuth, firestore: mockFirestore);
  });

  group("Login", () {
    test('loginUserWithEmailAndPassword returns User on success', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authService.loginUserWithEmailAndPassword(
          'test@mail.com', 'password');

      expect(result, isNotNull);
      expect(result, mockUser);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@mail.com', password: 'password'))
          .called(1);
    });

    test('loginUserWithEmailAndPassword returns null on FirebaseAuthException',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final result = await authService.loginUserWithEmailAndPassword(
          'test@mail.com', 'password');

      expect(result, isNull);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@mail.com', password: 'password'))
          .called(1);
    });

    test('loginUserWithEmailAndPassword returns null on generic exception',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception());

      final result = await authService.loginUserWithEmailAndPassword(
          'test@mail.com', 'password');

      expect(result, isNull);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@mail.com', password: 'password'))
          .called(1);
    });
  });

  group('AuthService Tests', () {
    test('sendEmailVerificationLink calls sendEmailVerification', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      await authService.sendEmailVerificationLink();
      verify(mockUser.sendEmailVerification()).called(1);
    });

    test('sendPasswordResetLink calls sendPasswordResetEmail', () async {
      const email = 'test@example.com';
      await authService.sendPasswordResetLink(email);
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
    });

    test('loginUserWithEmailAndPassword signs in a user', () async {
      const email = 'test@example.com';
      const password = 'password';

      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result =
          await authService.loginUserWithEmailAndPassword(email, password);

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .called(1);
      expect(result, mockUser);
    });

    test('signout signs out a user', () async {
      await authService.signout();
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  test(
      'createUserWithUsernameEmailAndPassword creates a user and updates profile',
      () async {
    const email = 'test@example.com';
    const password = 'password';
    const username = 'testuser';

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirestore.collection('Users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(email)).thenReturn(mockDocumentReference);
    when(mockDocumentReference
            .set({'username': username, 'bio': 'Empty bio..', 'doneOnboarding': false}))
        .thenAnswer((_) async {});

    final result = await authService.createUserWithUsernameEmailAndPassword(
        username, email, password);

    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .called(1);
    verify(mockUser.updateDisplayName(username)).called(1);
    verify(mockCollectionReference.doc(email)).called(1);
    verify(mockDocumentReference
        .set({'username': username, 'bio': 'Empty bio..', 'doneOnboarding': false})).called(1);
    expect(result, mockUser);
  });

  test(
      'createUserWithUsernameEmailAndPassword returns null on FirebaseAuthException',
      () async {
    const email = 'test@example.com';
    const password = 'password';
    const username = 'testuser';

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    final result = await authService.createUserWithUsernameEmailAndPassword(
        username, email, password);

    expect(result, isNull);
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .called(1);
  });

  test(
      'createUserWithUsernameEmailAndPassword returns null on generic exception',
      () async {
    const email = 'test@example.com';
    const password = 'password';
    const username = 'testuser';

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenThrow(Exception());

    final result = await authService.createUserWithUsernameEmailAndPassword(
        username, email, password);

    expect(result, isNull);
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .called(1);
  });
}
