import 'package:flutter/material.dart';

// Helpbot and message bubbles
const Color userMessageBubbleColor = Color(0xFF99D2A9);
const Color botMessageBubbleColor = Colors.white;
const TextStyle messageAuthorTextStyle =
    TextStyle(fontSize: 13.0, color: Colors.black54);
const TextStyle botMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.black54);
const TextStyle userMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.white);
const Color helpScreenBorderColor = Color(0x4D99D2A9);

// Popup dialogs
const TextStyle popupDialogTitleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24.0,
  color: Color(0xFF7C8691),
);
const TextStyle popupDialogTextStyle = TextStyle(
  color: Color(0xffD3DAE0),
  fontWeight: FontWeight.w600,
  fontSize: 18.0,
);
ButtonStyle popupDialogButtonStyle = ButtonStyle(
  overlayColor: MaterialStateProperty.all(Colors.green.shade200),
  backgroundColor: MaterialStateProperty.all(const Color(0XFFFBAB4B)),
  padding:
      MaterialStateProperty.all(const EdgeInsets.only(right: 10.0, left: 10.0)),
);
const TextStyle popupDialogButtonTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
);

// Authorisation (login, signup, email validation)
const authTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15);
const welcomeTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 25);

// Trips scheduler panel widget
const TextStyle infoTextStyle =
    TextStyle(fontStyle: FontStyle.italic, fontSize: 18);
const TextStyle tripSchedulerTextStyle =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 18);
const TextStyle cyclistNumberTextStyle =
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500);
