class Message {
  final String _questionText;
  final String _questionAnswer;
  final String _topic;
  final bool _launch;

  Message(this._questionText, this._questionAnswer, this._topic,
      [this._launch = false]);

  String get questionText => _questionText;
  String get questionAnswer => _questionAnswer;
  String get topic => _topic;
  bool get launch => _launch;
}
