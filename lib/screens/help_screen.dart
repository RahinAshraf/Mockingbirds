import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';
import 'package:veloplan/widgets/message_bubble_widget.dart';

const url =
    'mailto:k20070238@kcl.ac.uk?subject=Help%20with%20app&body=Help%20me!';
HelpBotManager questions = HelpBotManager();

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<MessageBubble> _conversation = [
    MessageBubble(content: 'Hello. How can I help you?')
  ];
  String selectedTopic = "";
  List<TopicsList> choices = [];

  @override
  void initState() {
    choices = _displayTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpBot'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                children: UnmodifiableListView(_conversation),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0x4D99D2A9),
                  ),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: choices,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMail() async {
    // Android and iOS
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  List<TopicsList> _displayTopics() {
    List<TopicsList> tpcs = [];
    for (String topic in questions.getAllTopics()) {
      tpcs.add(TopicsList(
        topic: topic,
        onPressed: () {
          setState(() {
            selectedTopic = topic;
            choices = [];
            _displayQuestions();
          });
        },
      ));
    }
    return tpcs;
  }

  List<TopicsList> _displayQuestions() {
    List<TopicsList> tpcs = [];
    for (Message message in questions.getMessagesByTopic(selectedTopic)) {
      choices.add(TopicsList(
        topic: questions.getQuestionText(message),
        onPressed: () {
          setState(() {
            _conversation.add(MessageBubble(
                content: questions.getQuestionText(message),
                isSentByBot: false));
            _conversation.add(
                MessageBubble(content: questions.getQuestionAnswer(message)));
            choices = _displayTopics();
            if (questions.getLaunch(message)) {
              _sendMail();
            }
          });
        },
      ));
    }
    return tpcs;
  }
}

class TopicsList extends StatelessWidget {
  const TopicsList({required this.topic, required this.onPressed});
  final VoidCallback onPressed;
  final String topic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all<Color>(const Color(0x1A99D2A9)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            topic,
            style: const TextStyle(
              color: Color(0xFF99D2A9),
            ),
          )),
    );
  }
}
