import 'package:veloplan/models/answer.dart';
import 'package:veloplan/models/message.dart';

class HelpBotManager {
  Map<Message,Answer> questionAnswers = {};

  HelpBotManager( ){
    questionAnswers.putIfAbsent(Message("is this working?"), () => Answer("yes"));
  }

  Set<String> getAllMessageTexts(){
    Set<String> ret = {};
    for(Message question in questionAnswers.keys){
      ret.add(question.text);
    }
    return ret;
  }

  String getAnswerToQuestion(String questionText){
    for(Message question in questionAnswers.keys){
      if(question.text == questionText){
        return questionAnswers[question]!.text;
      }
    }
    return "Sorry I can't help";
  }
}