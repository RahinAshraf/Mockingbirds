import 'package:veloplan/models/message.dart';

class HelpBotManager {
  List<Message> _questionBank = [
    Message('How do I sign up?', 'Sign up on the main page.', 'Signup'),
    Message('How do I login?', 'Login on the main page.', 'Login'),
    Message('How do I plan a new journey?', 'Click the bike button.',
        'Planning Journey'),
    Message('I have another question that is not listed here.',
        'Please contact k20082541@kcl.ac.uk.', 'Other Question')
  ];

  List<String> getAllQuestions() {
    List<String> newlist = [];
    for (Message message in _questionBank) {
      newlist.add(message.questionText);
    }
    return newlist;
  }

  List<String> getAllTopics() {
    List<String> newlist = [];
    for (Message message in _questionBank) {
      newlist.add(message.topic);
    }
    return newlist;
  }

  String getQuestionText(String topic) {
    for (Message message in _questionBank) {
      if (message.topic == topic) {
        return message.questionText;
      }
    }
    return 'Internal error.';
  }

  String getQuestionAnswer(String topic) {
    for (Message message in _questionBank) {
      if (message.topic == topic) {
        return message.questionAnswer;
      }
    }
    return 'Internal error.';
  }
}
