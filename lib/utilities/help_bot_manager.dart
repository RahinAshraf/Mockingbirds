import 'package:veloplan/models/message.dart';
import "package:collection/collection.dart";

class HelpBotManager {
  Map questions = {};
  List<Message> data = [];

  HelpBotManager() {
    data = [
      Message('How do I login?', 'Log in on the main page.', 'Authorisation'),
      Message(
          'How do I sign up?', 'Sign up on the main page.', 'Authorisation'),
      Message(
          'How do I plan a new journey?',
          'Go back to the main screen and click the green bike button in the middle.',
          'Planning Journey'),
      Message(
          'I have another question that is not listed here.',
          'Sorry to hear that I couldn\'t answer your question. Feel free to send an email.',
          'Other Questions',
          true),
      // add new messages here
    ];
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

  bool getLaunch(Message message) {
    return message.launch;
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
}
