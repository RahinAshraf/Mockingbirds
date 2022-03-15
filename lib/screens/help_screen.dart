import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:veloplan/models/message.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';
import 'package:veloplan/widgets/message_bubble_widget.dart';
import '../styles/styling.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/choice_button_widget.dart';

String supportEmailUrl =
    'mailto:k20070238@kcl.ac.uk?subject=Help%20with%20app&body=Help%20me!';
HelpBotManager questions = HelpBotManager();

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    choices = _displayTopics();
    super.initState();
  }

  final List<MessageBubble> _conversation = [
    MessageBubble(text: 'Hello. This is HelpBot. How can I help you?')
  ];
  String selectedTopic = "";
  List<ChoiceButton> choices = [];

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
      await launch(supportEmailUrl);
    } catch (e) {
      throw 'Could not launch $supportEmailUrl';
    }
  }

  List<ChoiceButton> _displayTopics() {
    List<ChoiceButton> topicButtons = [];
    for (String topic in questions.getAllTopics()) {
      topicButtons.add(ChoiceButton(
        name: topic,
        onPressed: () {
          setState(() {
            selectedTopic = topic;
            _displayQuestions();
          });
        },
      ));
    }
    return topicButtons;
  }

  List<ChoiceButton> _displayQuestions() {
    choices = [];
    for (Message message in questions.getMessagesByTopic(selectedTopic)) {
      choices.add(ChoiceButton(
        name: questions.getQuestionText(message),
        onPressed: () {
          setState(() {
            choices = _displayTopics();
            _conversation.add(MessageBubble(
                text: questions.getQuestionText(message), isSentByBot: false));
            _conversation
                .add(MessageBubble(text: questions.getQuestionAnswer(message)));
            if (questions.getLaunch(message)) {
              _sendMail();
            }
          });
        },
      ));
    }
    return choices;
  }
}
