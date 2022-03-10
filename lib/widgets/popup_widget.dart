import 'package:flutter/material.dart';
import '../styles/styling.dart';

enum AlertType { warning, question }

class PopupWidget extends StatelessWidget {
  PopupWidget(
      {required this.title,
      required this.text,
      required this.children,
      required this.type});

  final String title;
  final String text;
  final List<PopupButtonWidget> children;
  final AlertType type;

  String questionImage = "assets/images/popup_question.png";
  String warningImage = "assets/images/popup_warning.png";

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, -0.28),
      children: [
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0.0),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(text),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
                decoration: const BoxDecoration(
                  color: Color(0XFFF1F5F8),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: children,
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          type == AlertType.question ? questionImage : warningImage,
          height: 72,
        ),
      ],
    );
  }
}

class PopupButtonWidget extends StatelessWidget {
  const PopupButtonWidget({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2, left: 2),
      child: TextButton(
        style: popupDialogButtonStyle,
        onPressed: onPressed,
        child: Text(text, style: popupDialogButtonTextStyle),
      ),
    );
  }
}
