import 'package:flutter/material.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';
import 'dart:collection';

HelpBotManager questions = HelpBotManager();

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<MessageBubble> _conversation = [
    MessageBubble(
        text: 'Hello. How can I help you?', sender: 'Bot', isSentByBot: true)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HELP BOT'),
        backgroundColor: Color(0xFF99D2A9),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: UnmodifiableListView(_conversation),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0x4D99D2A9),
                  ),
                ),
              ),
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (var topic in questions.getAllTopics())
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: OutlinedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Color(0x1A99D2A9)),
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
                                    sender: 'User',
                                    isSentByBot: false));
                                _conversation.add(MessageBubble(
                                    text: questions.getQuestionAnswer(topic),
                                    sender: 'Bot',
                                    isSentByBot: true));
                              });
                            },
                            child: Text(
                              topic,
                              style: TextStyle(
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
}

//   AppBar buildAppBar() {
//     return AppBar(
//       title: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(
//                 'https://cdn.vox-cdn.com/thumbor/qCfHPH_9Mw78vivDlVDMu7xYc78=/715x248:1689x721/920x613/filters:focal(972x299:1278x605):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/69305239/shrek4_disneyscreencaps.com_675.0.jpg'),
//           ),
//           SizedBox(width: 30),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [Text("HelpBot")],
//           )
//         ],
//       ),
//     );
//   }
// }

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.text, required this.sender, required this.isSentByBot});

  final String text;
  final String sender;
  final bool isSentByBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isSentByBot ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isSentByBot
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isSentByBot ? Color(0xFF99D2A9) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15.0,
                    color: isSentByBot ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
