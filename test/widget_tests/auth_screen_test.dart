import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:veloplan/screens/auth_screen.dart';
import 'package:veloplan/widgets/auth/auth_form.dart';

class MockFirebaseUser extends Mock implements User {}

final _mockUser = MockFirebaseUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

class MockAuthResult extends Mock implements UserCredential {}

void main() async {
  String firstName;
  String lastName;
  String username;
  String password;
  String passwordConfirmation;
  String email;
  DateTime dateOfBirth;
  Function submitFn;

  final authScreen = AuthScreen();

  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();

  setUp(() async {
    firstName = "John";
    lastName = "Doe";
    username = "johndoe";
    password = "Password123";
    passwordConfirmation = "Password123";
    email = "john.doe@example.org";
    dateOfBirth = DateTime(2000);

    await Firebase.initializeApp();
  });

  testWidgets('Renders authentication', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: authScreen,
      ),
    );
  });
}
