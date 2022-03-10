import 'package:flutter/material.dart';
import 'package:veloplan/screens/help_screen.dart';
import '../styles/styling.dart';

const String botName = 'HelpBot';
const String userName = 'You';

/// Creates a message bubble used in [HelpPage].
///
/// This widget differentiates between a bot message bubble
/// and user chat bubble (uses different styling for different parties).
///
/// By default, the chat bubble is created for bots' messages, therefore
/// [isSentByBot] equals to true. If [isSentByBot] is set to false,
/// the message bubble is created for the user.
class MessageBubble extends StatelessWidget {
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
