// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:veloplan/widgets/message_bubble_widget.dart';
//
// void main() {
//   final userMessage = MessageBubble(text: 'Some User Text', isSentByBot: false);
//   final botMessage = MessageBubble(text: 'Some Bot Text');
//
//   group("Widget displays the name and the message correctly ", () {
//     testWidgets("in bot message bubble widget", (WidgetTester tester) async {
//       await tester.pumpWidget(
//         Directionality(textDirection: TextDirection.ltr, child: botMessage),
//       );
//       expect(find.text(botName), findsOneWidget);
//       expect(find.text('Some Bot Text'), findsOneWidget);
//     });
//     testWidgets("in user message bubble widget", (WidgetTester tester) async {
//       await tester.pumpWidget(
//         Directionality(textDirection: TextDirection.ltr, child: userMessage),
//       );
//       expect(find.text(userName), findsOneWidget);
//       expect(find.text('Some User Text'), findsOneWidget);
//     });
//   });
//
//   group("Widget displays the styling correctly", () {
//     testWidgets("in bot message bubble widget", (WidgetTester tester) async {
//       await tester.pumpWidget(
//           Directionality(textDirection: TextDirection.ltr, child: botMessage));
//
//       var testColumnAlignment =
//           tester.firstWidget(find.byKey(Key('alignmentKey'))) as Column;
//       var testMessageTextStyle =
//           tester.firstWidget(find.text('Some Bot Text')) as Text;
//       var testMaterialWidget =
//           tester.firstWidget(find.byType(Material)) as Material;
//       var testBorder = testMaterialWidget.borderRadius as BorderRadius;
//
//       expect(testColumnAlignment.crossAxisAlignment, CrossAxisAlignment.start);
//       expect(testMessageTextStyle.style, botMessageTextStyle);
//       expect(testMaterialWidget.color, botMessageBubbleColor);
//       expect(testBorder.topLeft, Radius.zero);
//     });
//
//     testWidgets("in user message bubble widget", (WidgetTester tester) async {
//       await tester.pumpWidget(
//           Directionality(textDirection: TextDirection.ltr, child: userMessage));
//
//       var testColumnAlignment =
//           tester.firstWidget(find.byKey(Key('alignmentKey'))) as Column;
//       var testMessageTextStyle =
//           tester.firstWidget(find.text('Some User Text')) as Text;
//       var testMaterialWidget =
//           tester.firstWidget(find.byType(Material)) as Material;
//       var testBorder = testMaterialWidget.borderRadius as BorderRadius;
//
//       expect(testColumnAlignment.crossAxisAlignment, CrossAxisAlignment.end);
//       expect(testMessageTextStyle.style, userMessageTextStyle);
//       expect(testMaterialWidget.color, userMessageBubbleColor);
//       expect(testBorder.topRight, Radius.zero);
//     });
//   });
// }
