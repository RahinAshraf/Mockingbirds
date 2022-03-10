import 'package:flutter/material.dart';

// General

// Appbar
const Color appBarColor = Color(0xFF99D2A9);
const Color appBarTextColor = Colors.white;

// Navbar

// Sidebar
const TextStyle sidebarItemTextStyle = TextStyle(color: Colors.green);

// Helpbot and message bubbles
const helpPageTopicButtonTextStyle = TextStyle(
  color: Color(0xFF99D2A9),
);
const Color userMessageBubbleColor = Color(0xFF99D2A9);
const Color botMessageBubbleColor = Colors.white;
const TextStyle messageAuthorTextStyle =
    TextStyle(fontSize: 13.0, color: Colors.black54);
const TextStyle botMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.black54);
const TextStyle userMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.white);

// Alerts
const Color alertSnackBarBackgroundColor = Colors.red;
const TextStyle alertTextStyle = TextStyle(fontSize: 17);

// Generic reusable button styles; this is from helpbot
// TODO MARIJA: make this work
ButtonStyle outlinedButtonStyle = ButtonStyle(
  overlayColor: MaterialStateProperty.all<Color>(const Color(0x1A99D2A9)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

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
);
const TextStyle popupDialogButtonTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);

// Authorisation
ButtonStyle authButtonStyle = ButtonStyle(
  minimumSize: MaterialStateProperty.all(const Size(251, 46)),
  overlayColor: MaterialStateProperty.all(Colors.green),
  backgroundColor: MaterialStateProperty.all(const Color(0xFF99D2A9)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
);

const authButtonTextStyle =
    TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w700);
