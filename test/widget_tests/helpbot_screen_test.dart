// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:veloplan/screens/help_screen.dart';
// import 'package:veloplan/widgets/message_bubble_widget.dart';
// import 'package:veloplan/utilities/help_bot_manager.dart';
//
// void main() {
//   final helpPage = HelpPage();
//   final helpBotManager = HelpBotManager();
//   const someExistingTopic =
//       'Login'; // to find a button with existing topic easier
//
//   testWidgets("Welcome text by bot once helpbot is loaded",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: helpPage));
//     expect(find.byType(MessageBubble), findsOneWidget);
//     var testWelcomeMessage =
//         tester.firstWidget(find.byType(MessageBubble)) as MessageBubble;
//     expect(testWelcomeMessage.isSentByBot, true);
//   });
//
//   testWidgets(
//       "Display a list of all possible topics with outlined button widget",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: helpPage));
//     expect(find.byType(OutlinedButton),
//         findsNWidgets(helpBotManager.getAllTopics().length));
//   });
//
//   testWidgets(
//       "When clicked on a topic, a question (by user), followed with an answer (by bot) should appear",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: helpPage));
//
//     // Ensure that at the beginning we only have one MessageBubble widget on the screen
//     expect(find.byType(MessageBubble), findsOneWidget);
//
//     await tester.tap(find.text(someExistingTopic));
//     await tester.pump();
//
//     expect(find.byType(MessageBubble), findsNWidgets(3));
//     var testConversation = tester.allWidgets.whereType<MessageBubble>();
//     // We know that the 0'th element is the initial welcoming message, so we do not check it
//     // Element at 1st index should be question MessageBubble, sent by user
//     expect(testConversation.elementAt(1).text,
//         helpBotManager.getQuestionText(someExistingTopic));
//     expect(testConversation.elementAt(1).isSentByBot, false);
//     // Element at 2nd index should be answer MessageBubble, sent by bot
//     expect(testConversation.elementAt(2).text,
//         helpBotManager.getQuestionAnswer(someExistingTopic));
//     expect(testConversation.elementAt(2).isSentByBot, true);
//   });
// }