import 'package:veloplan/models/message.dart';

/// Helper for [HelpScreen] storing [messageBank] and methods for its content retrieval.
/// Authors: Lilianna, Marija
/// Contributor: Hristina
class HelpBotManager {
  Map questions = {};
  List<Message> messageBank = [];

  /// The default URL for sending enquiries.
  static const String mailUrl =
      'mailto:mockingBirddddddd@outlook.com?subject=Help%20with%20app&body=Help%20me!';

  /// Link to Santander website.
  static const String webUrl =
      'https://tfl.gov.uk/modes/cycling/santander-cycles';

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
          'How do I share a journey with my friends?',
          'The first person who creates a journey can generate a code by clicking \'Share Journey\'. Then you can share this code with your friends.',
          'Planning a Journey'),
      Message(
          'Why can I not schedule a group journey for the future?',
          'This feature is not available yet for scheduled journeys.',
          'Planning a Journey'),
      Message(
          'How to plan a journey?',
          'Tap on the bike button on the main page and click \'Plan a journey\' option. You can then enter your trip details: number of cyclists, date, and destinations',
          'Planning a Journey'),
      Message(
          'Can I search for a destination outside of London?',
          'No. This app is only available for use in London.',
          'Planning a Journey'),
      Message(
          'Why is the number of cyclist important?',
          'Docking stations may not provide enough spaces for your group. We check for the number of available spaces that you enter at the starting point.',
          'Planning a Journey'),
      Message(
          'Do I get redirected during my journey to an available docking station?',
          'You have an option to do so.',
          'Planning a Journey'),
      Message(
          'How to I book a bicycle?',
          'You cannot book a bicycle through us. You should check out Santander website.',
          'Planning a Journey',
          webUrl),
      Message(
          'What are my journeys?',
          'These are the list of docking stations that you specify when you start a journey.',
          'My Journeys'),
      Message(
          'I have another question that is not listed here.',
          'Sorry to hear that I couldn\'t answer your question. Feel free to send an email.',
          'Other Questions',
          mailUrl),
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
  String getLaunch(Message message) {
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
