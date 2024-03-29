import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/providers/help_bot_manager.dart';
import 'package:veloplan/widgets/message_bubble_widget.dart';

HelpBotManager questions = HelpBotManager();

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

/// Renders a chat-based help (FAQ) page.
///
/// It consists of [MessageBubble] widgets, stored in [_conversation],
/// and [choices], which are the categories/topics that user can choose
/// to ask questions from.
/// Authors: Lilianna, Marija
/// Contributor: Tayyibah
class _HelpScreenState extends State<HelpScreen> {
  List<MessageBubble> _conversation = [
    MessageBubble(content: 'Hello. How can I help you?')
  ]; // conversation flow between a bot and a user
  List<Widget> choices = [];
  String selectedTopic = "";

  @override
  void initState() {
    choices = _displayTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('VeloBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: UnmodifiableListView(_conversation),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.5,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
            child: SingleChildScrollView(
              key: Key("questions"),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: choices,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Launches a given url (in our case, opens a mailing app or a website).
  _openUrl(Message message) async {
    // Android and iOS
    try {
      await launch(message.launch);
    } catch (e) {
      throw 'Could not launch.';
    }
  }

  /// Displays generic topics/categories to choose questions from.
  List<Widget> _displayTopics() {
    List<Widget> topics = [];
    for (String topic in questions.getAllTopics()) {
      topics.add(
        _getOutlinedButton(
          content: Text(topic),
          onPressed: () {
            setState(() {
              selectedTopic = topic;
              choices = [];
              _displayQuestions();
            });
          },
        ),
      );
    }
    return topics;
  }

  /// Displays a set of questions from a specific category.
  void _displayQuestions() {
    choices.add(
      _getOutlinedButton(
        content:
            const Icon(Icons.arrow_back, key: Key("back"), color: Colors.green),
        onPressed: () {
          setState(() {
            choices = _displayTopics();
          });
        },
      ),
    );
    for (Message message in questions.getMessagesByTopic(selectedTopic)) {
      choices.add(
        _getOutlinedButton(
          content: Text(questions.getQuestionText(message)),
          onPressed: () {
            setState(() {
              _conversation.add(MessageBubble(
                  content: questions.getQuestionText(message),
                  isSentByBot: false));
              _conversation.add(
                  MessageBubble(content: questions.getQuestionAnswer(message)));
              choices = _displayTopics();
              if (questions.getLaunch(message) != "") {
                _openUrl(message);
              }
            });
          },
        ),
      );
    }
  }

  /// Generates an outlined button for the topics/categories and questions.
  Widget _getOutlinedButton(
      {required Widget content, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(onPressed: onPressed, child: content),
    );
  }
}
