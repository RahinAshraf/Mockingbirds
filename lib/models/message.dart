import 'package:flutter/cupertino.dart';

class Message {
  final String questionText;
  final String questionAnswer;
  final String topic;
  bool launch = false;
  final String id;

  Message(this.questionText, this.questionAnswer, this.topic, this.id);

  void setLaunch(bool launch) {
    this.launch = launch;
  }
}
