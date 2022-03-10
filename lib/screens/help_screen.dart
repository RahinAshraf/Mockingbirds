import 'dart:collection';
import 'package:flutter/material.dart';
import '../styles/styling.dart';
import '../utilities/help_bot_manager.dart';
import '../widgets/message_bubble_widget.dart';

HelpBotManager questions = HelpBotManager();

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<MessageBubble> _conversation = [
    MessageBubble(text: 'Hello. How can I help you?')
  ];

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
                            style: outlinedButtonStyle,
                            onPressed: () {
                              setState(() {
                                _conversation.add(MessageBubble(
                                    text: questions.getQuestionText(topic),
                                    isSentByBot: false));
                                _conversation.add(MessageBubble(
                                    text: questions.getQuestionAnswer(topic)));
                              });
                            },
                            child: Text(topic,
                                style: helpPageTopicButtonTextStyle)),
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
}
