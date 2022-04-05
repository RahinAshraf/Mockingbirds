/// Represents a question message used in [HelpBotManager].
class Message {
  final String _questionText;
  final String _questionAnswer;
  final String _topic;
  final String _launch;

  Message(this._questionText, this._questionAnswer, this._topic,
      [this._launch = ""]);

  String get questionText => _questionText;
  String get questionAnswer => _questionAnswer;
  String get topic => _topic;
  String get launch => _launch;
}
