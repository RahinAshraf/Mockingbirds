import 'package:test/test.dart'; // unit tests
import 'package:veloplan/utilities/help_bot_manager.dart';

void main() {
  group("Should not throw an exception if nonexistent topic is passed to", () {
    final helpBotManager = HelpBotManager();
    test('getQuestionText method', () {
      helpBotManager.getQuestionText("sometopicthatdoesntexist");
    });
    test('getQuestionAnswer method', () {
      helpBotManager.getQuestionAnswer("somenonexistenttopic");
    });
  });
}
