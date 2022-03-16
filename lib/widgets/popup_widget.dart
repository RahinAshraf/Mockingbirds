import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../styles/styling.dart';

enum AlertType { warning, question }

extension AlertTypeString on AlertType {
  String get imagePath {
    switch (this) {
      case AlertType.warning:
        return "assets/images/popup_warning.png";
      case AlertType.question:
        return "assets/images/popup_question.png";
    }
  }
}

/// Creates a generic popup widget.
///
/// To avoid distorting the widget, there should be no more than
/// two [PopupButtonWidget]s passed in [children] property.
///
/// This widget has [type] property of [AlertType]. It determines the
/// image that should be rendered for the widget.
///
/// Some of the styling of this widget is specified in [Navbar]s [ThemeData]
/// property.
class PopupWidget extends StatelessWidget {
  const PopupWidget(
      {required this.title,
      required this.text,
      required this.children,
      required this.type});

  final String title;
  final String text;
  final List<PopupButtonWidget> children;
  final AlertType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
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
                padding: const EdgeInsets.only(
                    bottom: 10.0, right: 10.0, left: 10.0),
                child: Text(text, textAlign: TextAlign.center),
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
        Align(
          alignment: const Alignment(0, -0.40),
          child: Image.asset(
            type.imagePath,
            height: 72,
          ),
        ),
      ],
    );
  }
}

/// Generates a button for [PopupWidget].
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
