import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/styles/theme.dart';
import '../screens/schedule_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/help_screen.dart';
import 'styles/styling.dart';

///@author Tayyibah
//NOTE CHANGE NAME TO SIDEBAR
class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Image.asset(
            'assets/images/right_bubbles_shapes.png',
            height: 150,
            alignment: Alignment.topRight,
          ),
          buildSidebarItem(
            text: 'Schedule',
            icon: Icons.date_range,
            onClicked: () => _renderScreen(context, 0),
          ),
          buildSidebarItem(
            text: 'My Journeys',
            icon: Icons.history,
            onClicked: () => _renderScreen(context, 1),
          ),
          buildSidebarItem(
            text: 'Favourites',
            icon: Icons.favorite,
            onClicked: () => _renderScreen(context, 2),
          ),
          buildSidebarItem(
            text: 'Statistics',
            icon: Icons.assessment_outlined,
            onClicked: () => _renderScreen(context, 3),
          ),
          //NOTE MOVE THE COLOUR
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const SizedBox(height: 24),
          buildSidebarItem(
            text: 'Help',
            icon: Icons.chat_bubble_outlined,
            onClicked: () => _renderScreen(context, 4),
          ),
          buildSidebarItem(
            text: 'Settings',
            icon: Icons.settings,
            onClicked: () => _renderScreen(context, 5),
          ),
        ],
      ),
    );
  }

  Widget buildSidebarItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    return ListTile(
      leading: Icon(icon),
      //  textColor: CustomTheme.sideBarTextColor,
      title: Text(text, style: sidebarItemTextStyle),
      onTap: onClicked,
    );
  }

  _renderScreen(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Schedule(),
        ));
        break;
      case 1:
        // TODO: create 'My Journeys' screen
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
        // TODO: create 'Statistics' screen
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
          builder: (context) => const Settings(),
        ));
        break;
    }
  }
}
