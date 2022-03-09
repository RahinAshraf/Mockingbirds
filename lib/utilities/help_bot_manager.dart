import 'package:flutter/cupertino.dart';
import 'package:veloplan/models/message.dart';
import "package:collection/collection.dart";

class HelpBotManager {
  Map questions = {};
  var data;

  HelpBotManager(){
    data =[
      Message('How do I login?', 'Login on the main page.', 'Login',"1"),
      Message('How do I plan a new journey?', 'Click the bike button.',"2",
          'Planning Journey'),
      Message('How do I sign up?', 'Sign up on the main page.', 'Signup',"3"),
      Message('How do I sign up?', 'Sign up on the main page.', 'Signup',"4"),
      // add messages here



    ];
    Message otherQuestion = Message('I have another question that is not listed here.',
        'Please contact k20082541@kcl.ac.uk.', 'Other Question', "5");
    otherQuestion.setLaunch(true);
    data.add(otherQuestion);


    questions = _groupByTopic(data);
  }

  List<String> getAllTopics() {
    List<String> allTopics = [];
    for (String topic in questions.keys) {
        allTopics.add(topic);
      }
      return allTopics;
  }

  String getQuestionText(String id) {
    for (Message message in data) {
      if (message.id == id) {
        return message.questionText;
      }
    }
    return 'Internal error.';
  }

  List<Message> getQuestionsByTopic(String topic){
    return questions[topic];
  }

  String getQuestionAnswer(String id) {
    for (Message message in data) {
      if (message.id == id) {
        return message.questionAnswer;
      }
    }
    return 'Internal error.';
  }
  Map<String, List<Message>> _groupByTopic(var list){
    Map<String, List<Message>> resultMap = new Map();
    for (Message e in list) {
      resultMap.putIfAbsent(e.topic, () => _getAllQuestionsByTopic(e.topic));
    }
    return resultMap;
  }


  List<Message> _getAllQuestionsByTopic(String topic) {
    List<Message> lst=[];
    for (Message message in data) {
      if (message.topic == topic) {
        lst.add(message);
      }
    }
    return lst;
  }

}
