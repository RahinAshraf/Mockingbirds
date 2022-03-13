import 'package:veloplan/models/message.dart';

class HelpBotManager {
  Map questions = {};
  List<Message> data = [];

  HelpBotManager() {
    data = [
      Message('How do I login?', 'Login on the main page.', 'Authorisation'),
      Message('How do I plan a new journey?', 'Click the bike button.',
          'Planning Journey'),
      Message('How do I sign up?', 'Sign up on the main page.', 'Signup'),
      Message('How do I up?', 'Sign up.', 'Signup'),
      // add messages here
    ];
    Message otherQuestion = Message(
        'I have another question that is not listed here.',
        'Please contact k20082541@kcl.ac.uk.',
        'Other Question');
    otherQuestion.setLaunch(true);
    data.add(otherQuestion);

    questions = _groupByTopic(data);
  }

  List getAllTopics() {
    return questions.keys.toList();
  }

  List<Message> getMessagesByTopic(String topic) {
    return questions[topic];
  }

  String getQuestionText(Message message) {
    return message.questionText;
  }

  String getQuestionAnswer(Message message) {
    return message.questionAnswer;
  }

  Map<String, List<Message>> _groupByTopic(List<Message> list) {
    Map<String, List<Message>> resultMap = {};
    for (Message message in list) {
      resultMap.putIfAbsent(
          message.topic, () => _getAllQuestionsByTopic(message.topic));
    }
    return resultMap;
  }

  List<Message> _getAllQuestionsByTopic(String topic) {
    List<Message> questions = [];
    for (Message message in data) {
      if (message.topic == topic) {
        questions.add(message);
      }
    }
    return questions;
  }

  bool getLaunch(String question) {
    for (Message message in data) {
      if (message.questionText == question) {
        return message.launch;
      }
    }
    return false;
  }
}
