import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/screens/sidebar_screens/settings_screen.dart';

//Author: Hristina
void main() {
  testWidgets(WidgetTester tester) async {
    await tester.pumpWidget(const Settings());
    // Get Find reference and get a Scaffold type for assert it.
    var scaffold = find.byType(Scaffold);
    expect(scaffold, findsOneWidget);
  }

  ;
}
