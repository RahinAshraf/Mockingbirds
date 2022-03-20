import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';
import 'package:veloplan/widgets/helpbot/choices_button_widget.dart';
import 'package:veloplan/widgets/helpbot/message_bubble_widget.dart';

const String url =
    'mailto:k20070238@kcl.ac.uk?subject=Help%20with%20app&body=Help%20me!';
HelpBotManager questions = HelpBotManager();

// STYLING
const Color helpScreenBorderColor = Color(0x4D99D2A9);

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<MessageBubble> _conversation = [
    MessageBubble(content: 'Hello. How can I help you?')
  ];
  List<ChoiceButton> choices = [];
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
                    color: helpScreenBorderColor,
                    width: 1.5,
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
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

  List<ChoiceButton> _displayTopics() {
    List<ChoiceButton> topics = [];
    for (String topic in questions.getAllTopics()) {
      topics.add(ChoiceButton(
        content: Text(topic, style: helpbotChoiceTextStyle),
        onPressed: () {
          setState(() {
            selectedTopic = topic;
            choices = [];
            _displayQuestions();
          });
        },
      ));
    }
    return topics;
  }

  void _displayQuestions() {
    choices.add(
      ChoiceButton(
        content: const Icon(Icons.arrow_back, color: Colors.green),
        onPressed: () {
          setState(() {
            choices = _displayTopics();
          });
        },
      ),
    );
    for (Message message in questions.getMessagesByTopic(selectedTopic)) {
      choices.add(
        ChoiceButton(
          content: Text(questions.getQuestionText(message),
              style: helpbotChoiceTextStyle),
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
        ),
      );
    }
  }
}
