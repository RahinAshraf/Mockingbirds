import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/providers/help_bot_manager.dart';
import 'package:veloplan/screens/sidebar_screens/help_screen.dart';
import 'package:veloplan/widgets/message_bubble_widget.dart';

void main() {
  final helpScreen = HelpScreen();
  final helpBotManager = HelpBotManager();

  testWidgets("Welcome text by bot once helpbot is loaded",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: helpScreen));
    expect(find.byType(MessageBubble), findsOneWidget);
    var testWelcomeMessage =
        tester.firstWidget(find.byType(MessageBubble)) as MessageBubble;
    expect(testWelcomeMessage.isSentByBot, true);
  });

  testWidgets(
      "Display a list of all possible topics with outlined button widget",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: helpScreen));
    expect(find.byType(OutlinedButton),
        findsNWidgets(helpBotManager.getAllTopics().length));
  });

  testWidgets(
      "Display a list of all possible questions with outlined button widget within a topic",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: helpScreen));
    // Ensure that at the beginning we only have one MessageBubble widget on the screen
    expect(find.byType(MessageBubble), findsOneWidget);

    String topic = helpBotManager.getAllTopics()[0];
    await tester.tap(find.text(topic));
    await tester.pump();

    // Check that there is an arrow back
    expect(find.byKey(Key('back_topic')), findsOneWidget);
    // Check that there is the same number of questions + 1 (including the arrow back)
    expect(find.byType(OutlinedButton),
        findsNWidgets(helpBotManager.getMessagesByTopic(topic).length + 1));
    // No new messages were added, as we only switched between topics
    expect(find.byType(MessageBubble), findsOneWidget);
  });

  testWidgets(
      "Clicking on back arrow in questions list navigates user to topics list without adding anything to conversation",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: helpScreen));
    expect(find.byType(MessageBubble), findsOneWidget);

    String topic = helpBotManager.getAllTopics()[0];
    await tester.tap(find.text(topic));
    await tester.pump();
    await tester.tap(find.byKey(Key('back_topic')));
    await tester.pump();

    expect(find.byType(OutlinedButton),
        findsNWidgets(helpBotManager.getAllTopics().length));
    expect(find.byType(MessageBubble), findsOneWidget);
  });

  testWidgets(
      "When clicked on a question, a question (by user), followed with an answer (by bot) should appear",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: helpScreen));

    // Ensure that at the beginning we only have one MessageBubble widget on the screen
    expect(find.byType(MessageBubble), findsOneWidget);

    // Mimic clicking a topic, then clicking a question
    String topic = helpBotManager.getAllTopics()[0];
    await tester.tap(find.text(topic));
    await tester.pump();
    Message question = helpBotManager.getMessagesByTopic(topic)[0];
    await tester.tap(find.text(question.questionText));
    await tester.pump();

    // Retrieve all widgets that are of type MessageBubble
    var testConversation = tester.allWidgets.whereType<MessageBubble>();
    // We know that the 0'th element is the initial welcoming message, so we do not check it
    // Element at 1'st index should be question MessageBubble, sent by user
    expect(testConversation.elementAt(1).content,
        helpBotManager.getQuestionText(question));
    expect(testConversation.elementAt(1).isSentByBot, false);
    // Element at 2nd index should be answer MessageBubble, sent by bot
    expect(testConversation.elementAt(2).content,
        helpBotManager.getQuestionAnswer(question));
    expect(testConversation.elementAt(2).isSentByBot, true);
    // There should be three MessageBubble widgets on screen (including the welcoming message)
    expect(find.byType(MessageBubble), findsNWidgets(3));
    // The user should be navigated to topics list
    expect(find.byType(OutlinedButton),
        findsNWidgets(helpBotManager.getAllTopics().length));
  });
}
