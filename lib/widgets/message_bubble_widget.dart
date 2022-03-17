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

/// Creates a chat bubble used in HelpBotPage.
///
/// This widget differentiates between a bot chat bubble
/// and user chat bubble (uses different styling for different parties).
///
/// The [content] argument is required. It corresponds to the content
/// of a chat bubble.
///
/// By default, the chat bubble is created for bots' messages, therefore
/// [isSentByBot] equals to true. If [isSentByBot] is set to false,
/// the chat bubble is created for the user.
class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.content, this.isSentByBot = true});

  final String content;
  final bool isSentByBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        key: const Key('alignmentKey'),
        crossAxisAlignment:
            isSentByBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
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
                content,
                style: isSentByBot ? botMessageTextStyle : userMessageTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
