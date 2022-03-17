class Message {
  final String questionText;
  final String questionAnswer;
  final String topic;
  final bool launch;

  Message(this.questionText, this.questionAnswer, this.topic,
      [this.launch = false]);
}
