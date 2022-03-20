import 'package:flutter/material.dart';

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
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
