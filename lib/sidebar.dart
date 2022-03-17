import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/schedule_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/help_screen.dart';

///Author: Tayyibah

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 48),
          buildMenuItem(
            text: 'Schedule',
            icon: Icons.date_range,
            onClicked: () => selectedItem(context, 0),
          ),
          buildMenuItem(
            text: 'My Journeys',
            icon: Icons.history,
            onClicked: () => selectedItem(context, 1),
          ),
          buildMenuItem(
            text: 'Favourites',
            icon: Icons.favorite,
            onClicked: () => selectedItem(context, 2),
          ),
          buildMenuItem(
            text: 'Statistics',
            icon: Icons.assessment_outlined,
            onClicked: () => selectedItem(context, 3),
          ),
          //decided to remove this, not sure if it looks nice
          const SizedBox(height: 24),
          Divider(color: Colors.grey),
          const SizedBox(height: 24),
          buildMenuItem(
            text: 'Help',
            icon: Icons.chat_bubble_outlined,
            onClicked: () => selectedItem(context, 4),
          ),
          buildMenuItem(
            text: 'Settings',
            icon: Icons.settings,
            onClicked: () => selectedItem(context, 5),
          ),
          buildMenuItem(
            text: 'Log Out',
            icon: Icons.logout,
            onClicked: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyle(color: Colors.green)),
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int i) {
    //Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Schedule(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Placeholder(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Favourite(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Placeholder(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HelpPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Settings(),
        ));
        break;
    }
  }
}
