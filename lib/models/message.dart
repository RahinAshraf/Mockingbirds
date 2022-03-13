class Message {
  final String questionText;
  final String questionAnswer;
  final String topic;
  bool launch = false;

  Message(this.questionText, this.questionAnswer, this.topic);

  void setLaunch(bool launch) {
    this.launch = launch;
  }
}
