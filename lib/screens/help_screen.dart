import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';
<<<<<<< HEAD
import '../styles/styling.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/helpbot/message_bubble_widget.dart';
=======
import 'package:veloplan/widgets/message_bubble_widget.dart';
>>>>>>> main

HelpBotManager questions = HelpBotManager();

<<<<<<< HEAD
// CONSTANTS
//const Color appBarColor = Color(0xFF99D2A9);

=======
>>>>>>> main
class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<MessageBubble> _conversation = [
    MessageBubble(text: 'Hello. How can I help you?')
  ];
<<<<<<< HEAD
=======
  List<Widget> choices = [];
  String selectedTopic = "";
>>>>>>> main

  _sendMail() async {
    // Android and iOS
    const url = 'mailto:k20070238@kc.ac.uk?subject=Help%20with%20app&body=Test';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpBot'),
        backgroundColor: appBarColor,
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
                  children: <Widget>[
                    for (var topic in questions.getAllTopics())
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: OutlinedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  const Color(0x1A99D2A9)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _conversation.add(MessageBubble(
                                    text: questions.getQuestionText(topic),
                                    isSentByBot: false));
                                _conversation.add(MessageBubble(
                                    text: questions.getQuestionAnswer(topic)));
                              });
                              if (questions.getLaunch(topic)) {
                                _sendMail();
                              }
                            },
                            child: Text(
                              topic,
                              style: const TextStyle(
                                color: Color(0xFF99D2A9),
                              ),
                            )),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  _sendMail() async {
    // Android and iOS
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

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

  void _displayQuestions() {
    choices.add(
      _getOutlinedButton(
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
              if (questions.getLaunch(message)) {
                _sendMail();
              }
            });
          },
        ),
      );
    }
  }

  Widget _getOutlinedButton(
      {required Widget content, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(onPressed: onPressed, child: content),
    );
  }
>>>>>>> main
}
