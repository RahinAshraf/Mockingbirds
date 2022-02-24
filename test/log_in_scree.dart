import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/screens/auth_screen.dart';
import 'package:veloplan/widgets/auth/auth_form.dart';
import 'package:veloplan/screens/login_screen.dart';
import 'package:mockito/mockito.dart';

// source: https://github.com/bizz84/coding-with-flutter-login-demo/tree/master/test

class MockAuth extends Mock implements BaseAuth {}

void main() {
  Widget makeTestableWidget({Widget child, BaseAuth auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('email or password is empty, does not sign in',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    Login page = Login(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    await tester.tap(find.byKey(Key('signIn')));

    verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
    expect(didSignIn, false);
  });

  testWidgets(
      'non-empty email and password, valid account, call sign in, succeed',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithEmailAndPassword('email', 'password'))
        .thenAnswer((invocation) => Future.value('uid'));

    bool didSignIn = false;
    Login page = Login(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(const Key('signIn')));

    verify(mockAuth.signInWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, true);
  });

  testWidgets(
      'non-empty email and password, valid account, call sign in, fails',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithEmailAndPassword('email', 'password'))
        .thenThrow(StateError('invalid credentials'));

    bool didSignIn = false;
    Login page = Login(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(const Key('signIn')));

    verify(mockAuth.signInWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, false);
  });
}
