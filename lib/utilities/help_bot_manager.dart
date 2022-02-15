import 'package:veloplan/models/answer.dart';
import 'package:veloplan/models/message.dart';

class HelpBotManager {
  Map<Message, Answer> questionAnswers = {};

  HelpBotManager() {
    questionAnswers.putIfAbsent(
        Message("test", "is this working?1"), () => Answer("yes"));
    questionAnswers.putIfAbsent(
        Message("test2", "is this working?2"), () => Answer("yes"));
    questionAnswers.putIfAbsent(
        Message("test3", "is this working?3"), () => Answer("yes"));
  }

  Set<String> getAllMessageTopics() {
    Set<String> ret = {};
    for (Message question in questionAnswers.keys) {
      ret.add(question.topic);
    }
    return ret;
  }

  String getMessageTextsbyTopic(String topic) {
    for (Message question in questionAnswers.keys) {
      if (question.topic == topic) {
        return question.text;
      }
    }
    return "Internal error. Please reload.";
  }

  String getAnswerToQuestion(String questionTopic) {
    for (Message question in questionAnswers.keys) {
      if (question.topic == questionTopic) {
        return questionAnswers[question]!.text;
      }
    }
    return "Sorry I can't help";
  }
}
