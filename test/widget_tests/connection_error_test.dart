import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/widgets/connection_error_widget.dart';

void main() {
  final connectionError = ConnectionError();
  testWidgets("display connection error ", (WidgetTester tester) async {
    final internetErrorSpanner = find.byKey(ValueKey("internetErrorSpanner"));
    final internetErrorText = find.byKey(ValueKey("internetErrorText"));
    await tester.pumpWidget(MaterialApp(home: connectionError));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
        find.text("Reconnecting... \n please check your internet connection"),
        findsOneWidget);
  });
}
