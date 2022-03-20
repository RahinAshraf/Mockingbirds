import 'package:flutter/material.dart';

// CONSTANTS
const String botName = 'HelpBot';
const String userName = 'You';
const Color userMessageBubbleColor = Color(0xFF99D2A9);
const Color botMessageBubbleColor = Colors.white;
const TextStyle messageAuthorTextStyle =
    TextStyle(fontSize: 13.0, color: Colors.black54);
const TextStyle botMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.black54);
const TextStyle userMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.white);

class MessageBubble extends StatelessWidget {
  /// Creates a chat bubble used in HelpBotPage.
  ///
  /// This widget differentiates between a bot chat bubble
  /// and user chat bubble (uses different styling for different parties).
  ///
  /// The [text] argument is required. It corresponds to the content
  /// of a chat bubble.
  ///
  /// By default, the chat bubble is created for bots' messages, therefore
  /// [sender] is the name of the bot and [isSentByBot] equals to
  /// true. If [sender] is specified, the chat bubble is created for the user,
  /// and therefore [isSentByBot] must be set to false.

  MessageBubble({required this.text, this.isSentByBot = true});

  final String text;
  final bool isSentByBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        key: const Key('alignmentKey'),
        crossAxisAlignment:
            isSentByBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            isSentByBot ? botName : userName,
            style: messageAuthorTextStyle,
          ),
          Material(
            borderRadius: isSentByBot
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isSentByBot ? botMessageBubbleColor : userMessageBubbleColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: isSentByBot ? botMessageTextStyle : userMessageTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
