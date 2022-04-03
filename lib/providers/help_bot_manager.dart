import 'package:veloplan/models/message.dart';

/// Helper for [HelpScreen] storing [messageBank] and methods for its content retrieval.
/// Authors: Lilianna, Marija
class HelpBotManager {
  Map questions = {};
  List<Message> messageBank = [];

  HelpBotManager() {
    messageBank = [
      Message(
          'How do I delete my account?',
          'Go to settings page and select \'Delete account\' option. You will have to enter your password to confirm deletion. This process is irreversible.',
          'Account'),
      Message('How do I log out?',
          'Head to settings and choose \'Log Out\' option.', 'Account'),
      Message('How do I change my password?',
          'Head to settings and choose \'Change password\' option.', 'Account'),
      Message(
          'What are suggested journeys?',
          'Suggested journeys are pre-defined trips that take you around some of the most popular destinations in London.',
          'Suggested Journeys'),
      Message(
          'How can I go on a suggested journey?',
          'Go to \'Suggested Journeys\' page in sidebar.',
          'Suggested Journeys'),
      Message('Can I search for a destination outside of London?', 'No.',
          'Planning a Journey'),
      Message(
          'I have another question that is not listed here.',
          'Sorry to hear that I couldn\'t answer your question. Feel free to send an email.',
          'Other Questions',
          true),
    ];
    questions = _groupByTopic(messageBank);
  }

  /// Returns a list of all topics.
  List getAllTopics() {
    return questions.keys.toList();
  }

  /// Returns all the messages that are of [topic].
  List<Message> getMessagesByTopic(String topic) {
    return questions[topic];
  }

  /// Returns the question of the [message].
  String getQuestionText(Message message) {
    return message.questionText;
  }

  /// Returns answer of the [message].
  String getQuestionAnswer(Message message) {
    return message.questionAnswer;
  }

  /// Returns whether [message] launches another screen or not.
  bool getLaunch(Message message) {
    return message.launch;
  }

  /// Groups [messages] by topic.
  Map<String, List<Message>> _groupByTopic(List<Message> messages) {
    Map<String, List<Message>> resultMap = {};
    for (Message message in messages) {
      resultMap.putIfAbsent(
          message.topic, () => _getAllQuestionsByTopic(message.topic));
    }
    return resultMap;
  }

  /// Retrieves all the messages that have [topic].
  List<Message> _getAllQuestionsByTopic(String topic) {
    List<Message> questions = [];
    for (Message message in messageBank) {
      if (message.topic == topic) {
        questions.add(message);
      }
    }
    return questions;
  }
}
