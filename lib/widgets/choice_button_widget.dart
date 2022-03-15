import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({required this.name, required this.onPressed});

  final VoidCallback onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all<Color>(const Color(0x1A99D2A9)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFF99D2A9),
            ),
          )),
    );
  }
}
