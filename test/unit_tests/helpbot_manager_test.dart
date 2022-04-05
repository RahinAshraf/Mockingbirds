import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/providers/help_bot_manager.dart';

void main() {
  late HelpBotManager _helpBotManager;
  late Message message1;
  late Message message3;
  late Message message2;

  setUp(() {
    _helpBotManager = HelpBotManager();
    message1 = Message('How do I delete test?', 'Go to tests', 'Test');
    message3 = Message('How do I delete test?', 'Go to tests', 'Test', '');
    message2 = Message('How do I  test?', 'Go to tests', 'Test2');
    _helpBotManager.questions = {
      'Test': [message1, message3],
      'Test2': [message2]
    };
  });

  test('Returns all topics', () async {
    expect(_helpBotManager.getAllTopics().length, 2);
  });

  test('Returns all messager per topic', () async {
    expect(_helpBotManager.getMessagesByTopic("Test").length, 2);
  });
  test('Returns the correct information for messages', () async {
    expect(_helpBotManager.getQuestionAnswer(message1), 'Go to tests');
    expect(_helpBotManager.getQuestionText(message1), 'How do I delete test?');
  });

  test(' Correctly returns the correct leunch for messages', () async {
    expect(_helpBotManager.getLaunch(message1), false);
    expect(_helpBotManager.getLaunch(message3), true);
  });
}
