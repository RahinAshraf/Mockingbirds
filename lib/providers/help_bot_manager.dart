import 'package:veloplan/models/message.dart';

/// Helper for [HelpScreen] storing [messageBank] and methods for its content retrieval.
/// Authors: Lilianna, Marija
/// Contributor: Hristina
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
      Message(
          'How do I share a journey with my friends?',
          'The first person who creates a journey will receive a generated code. Then you can introduce this code when you join a group.',
          'Planning a Journey'),
      Message(
          'How to plan a journey?',
          'Tap on the bike icon from the bottom of screen and you will see a pop up with 2 questions. Select \'Plan a journey\' and introduce your journey details.',
          'Planning a Journey'),
      Message('Can I search for a destination outside of London?', 'No.',
          'Planning a Journey'),
      Message(
          'Can I schedule a journey for a group?', 'No.', 'Planning a Journey'),
      Message(
          'Why is the number of cyclist important?',
          'Docking stations may not provide enough spaces for your group.',
          'Planning a Journey'),
      Message('Can I tap on the map when planning a journey?', 'Yes.',
          'Planning a Journey'),
      Message(
          'Can I get redirected during my journey to an available docking station?',
          'Yes.',
          'Planning a Journey'),
      Message(
          'Is the dock information correct?',
          'Yes, but it does not include predicting availability ',
          'Planning a Journey'),
      Message(
          'How to I favourite a card?',
          'Tap on the docking station that you want to favourite and then, there is a favourite button. Click it and all your favourite docking stations will be in one place: \'Favourites\' from sidebar.',
          'Planning a Journey'),
      Message(
          'How to I book a bycicle?',
          'You cannot book a bycicle through us. You should link to Santander website.',
          'Planning a Journey'),
      Message(
          'I want to go on a journey, but the weather is bad, what do I do?',
          'You should check regurlaly on weather until the conditions are good enough.',
          'Planning a Journey'),
      Message(
          'How can I see more information about a docking station?',
          'Tap on map and see card with dock station info.',
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
