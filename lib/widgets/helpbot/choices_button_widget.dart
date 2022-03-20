import 'package:flutter/material.dart';

// STYLING
const TextStyle helpbotChoiceTextStyle = TextStyle(color: Color(0xFF99D2A9));
ButtonStyle helpbotChoiceButtonStyle = ButtonStyle(
  overlayColor: MaterialStateProperty.all(const Color(0x1A99D2A9)),
  shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
  side: MaterialStateProperty.all(
      const BorderSide(color: Color(0x4D99D2A9), width: 1.0)),
);

/// Generates a button for either a question or a topic
/// in bottom choices panel in [HelpPage].
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({required this.content, required this.onPressed});
  final VoidCallback onPressed;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(
        style: helpbotChoiceButtonStyle,
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
