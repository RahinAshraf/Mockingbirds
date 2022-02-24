import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/screens/auth_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:email_validator/email_validator.dart';

// source: https://github.com/bizz84/coding-with-flutter-login-demo/tree/master/test
void main() {
  test('empty email returns error string', () {
    final result = EmailValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('non-empty email returns null', () {
    final result = EmailValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {
    final result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {
    final result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}
