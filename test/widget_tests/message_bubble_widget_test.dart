import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/widgets/message_bubble_widget.dart';

/// Tests for [MessageBubble] widget.
void main() {
  var userMessage;
  var botMessage;

  setUpAll(() {
    userMessage = MessageBubble(
        content: 'This is the content of user message bubble.',
        isSentByBot: false);
    botMessage =
        MessageBubble(content: 'This is the content of bot message bubble.');
  });

  group("Widget displays the name and the message correctly ", () {
    testWidgets("in bot message bubble widget", (WidgetTester tester) async {
      await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: botMessage));
      expect(find.text(botName), findsOneWidget);
      expect(find.text('This is the content of bot message bubble.'),
          findsOneWidget);
    });
    testWidgets("in user message bubble widget", (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(textDirection: TextDirection.ltr, child: userMessage),
      );
      expect(find.text(userName), findsOneWidget);
      expect(find.text('This is the content of user message bubble.'),
          findsOneWidget);
    });
  });

  group("Widget displays the styling correctly", () {
    testWidgets("in bot message bubble widget", (WidgetTester tester) async {
      await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: botMessage));

      var testColumnAlignment =
          tester.firstWidget(find.byType(Column)) as Column;
      var testMessageAuthorTextStyle =
          tester.firstWidget(find.text(botName)) as Text;
      var testMessageTextStyle = tester.firstWidget(
          find.text('This is the content of bot message bubble.')) as Text;
      var testMaterialWidget =
          tester.firstWidget(find.byType(Material)) as Material;
      var testBorder = testMaterialWidget.borderRadius as BorderRadius;

      expect(testColumnAlignment.crossAxisAlignment, CrossAxisAlignment.start);
      expect(testMessageAuthorTextStyle.style, messageAuthorTextStyle);
      expect(testMessageTextStyle.style, botMessageTextStyle);
      expect(testMaterialWidget.color, botMessageBubbleColor);
      expect(testBorder.topLeft, Radius.zero);
    });

    testWidgets("in user message bubble widget", (WidgetTester tester) async {
      await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: userMessage));

      var testColumnAlignment =
          tester.firstWidget(find.byType(Column)) as Column;
      var testMessageAuthorTextStyle =
          tester.firstWidget(find.text(userName)) as Text;
      var testMessageTextStyle = tester.firstWidget(
          find.text('This is the content of user message bubble.')) as Text;
      var testMaterialWidget =
          tester.firstWidget(find.byType(Material)) as Material;
      var testBorder = testMaterialWidget.borderRadius as BorderRadius;

      expect(testColumnAlignment.crossAxisAlignment, CrossAxisAlignment.end);
      expect(testMessageAuthorTextStyle.style, messageAuthorTextStyle);
      expect(testMessageTextStyle.style, userMessageTextStyle);
      expect(testMaterialWidget.color, userMessageBubbleColor);
      expect(testBorder.topRight, Radius.zero);
    });
  });
}
