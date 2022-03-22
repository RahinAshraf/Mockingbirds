<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';

import '../screens/favourite_screen.dart';
import '../screens/help_screen.dart';
import '../screens/schedule_screen.dart';

///Author: Tayyibah

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  int index = 0;
  late String name = 'Place holder';
  late String nb_bikes = '0';
  late String nb_empty_docks = '0';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
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
            text: 'Summary Journey',
            icon: Icons.map_outlined,
            onClicked: () => selectedItem(context, 6),
          ),
          // buildMenuItem(
          //   text: 'Docking station',
          //   icon: Icons.map_outlined,
          //   onClicked: () => selectedItem(context, 7),
          // ),
          buildMenuItem(
            text: 'Log Out',
            icon: Icons.logout,
            onClicked: () => FirebaseAuth.instance.signOut(),
          ),
        ],
=======
import 'package:flutter/material.dart';
import 'package:veloplan/screens/favourite_screen.dart';
import 'package:veloplan/screens/help_screen.dart';
import 'package:veloplan/screens/schedule_screen.dart';
import 'package:veloplan/screens/settings_screen.dart';

/// Defines the sidebar
/// @author Tayyibah
class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            Image.asset(
              'assets/images/right_bubbles_shapes.png',
              height: 150,
              alignment: Alignment.topRight,
            ),
            _buildSidebarItem(
              text: 'Schedule',
              icon: Icons.date_range,
              onClicked: () => _renderScreen(context, 0),
            ),
            _buildSidebarItem(
              text: 'My Journeys',
              icon: Icons.history,
              onClicked: () => _renderScreen(context, 1),
            ),
            _buildSidebarItem(
              text: 'Favourites',
              icon: Icons.favorite,
              onClicked: () => _renderScreen(context, 2),
            ),
            _buildSidebarItem(
              text: 'Statistics',
              icon: Icons.assessment_outlined,
              onClicked: () => _renderScreen(context, 3),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 24),
            _buildSidebarItem(
              text: 'Help',
              icon: Icons.chat_bubble_outlined,
              onClicked: () => _renderScreen(context, 4),
            ),
            _buildSidebarItem(
              text: 'Settings',
              icon: Icons.settings,
              onClicked: () => _renderScreen(context, 5),
            ),
          ],
        ),
>>>>>>> main
      ),
    );
  }

<<<<<<< HEAD
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.green;

    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyle(color: color)),
=======
  Widget _buildSidebarItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
>>>>>>> main
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
          builder: (context) => const Placeholder(),
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
          builder: (context) => const Placeholder(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HelpPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
<<<<<<< HEAD
          builder: (context) => Placeholder(),
=======
          builder: (context) => const Settings(),
>>>>>>> main
        ));
        break;
      // case 7:
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>
      //         dockingsStationCard(index, name, nb_bikes, nb_empty_docks),
      //   ));
      //   break;
    }
  }
}
