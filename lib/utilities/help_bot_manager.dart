
import 'package:veloplan/models/message.dart';

class HelpBotManager {
  Map<Message,Message> questionAnswers = {};

  HelpBotManager( ){
    questionAnswers.putIfAbsent(Message("test","is this working?",false), () => Message("test","yes",true));
  }

  Set<Message> getAllMessageTexts(){
    Set<Message> ret = {};
    for(Message question in questionAnswers.keys){
      ret.add(question);
    }
    return ret;
  }

  Message getMessageTextsbyTopic(String questionTopic){
    for(Message question in questionAnswers.keys){
      if(question.topic == questionTopic){
        return question;
      }
    }
    return Message("error", "Internal error. Please reload", true);
  }


  Message? getAnswerToQuestion(String questionTopic){
    for(Message question in questionAnswers.keys){
      if(question.topic == questionTopic){
        return questionAnswers[question];
      }
    }
    return Message("error", "Internal error. Please reload", true);
  }
}