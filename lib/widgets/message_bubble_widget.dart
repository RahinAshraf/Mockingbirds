import 'package:flutter/material.dart';
import '../styles/styling.dart';

const String botName = 'HelpBot';
const String userName = 'You';

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

  const MessageBubble({required this.text, this.isSentByBot = true});

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
