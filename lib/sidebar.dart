import 'package:flutter/material.dart';
import 'package:veloplan/screens/suggested_journeys.dart';
import 'package:veloplan/screens/sidebar_screens/my_journeys_screen.dart';
import 'screens/sidebar_screens/schedule_screen.dart';
import 'screens/sidebar_screens/favourite_screen.dart';
import 'screens/sidebar_screens/help_screen.dart';
import 'screens/sidebar_screens/my_journeys_screen.dart';
import 'package:veloplan/screens/sidebar_screens/favourite_screen.dart';
import 'package:veloplan/screens/sidebar_screens/help_screen.dart';
import 'package:veloplan/screens/sidebar_screens/schedule_screen.dart';
import 'package:veloplan/screens/sidebar_screens/settings_screen.dart';

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
              text: 'Suggested Trips',
              icon: Icons.route,
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
      ),
    );
  }

  Widget _buildSidebarItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  _renderScreen(BuildContext context, int i) async {
    switch (i) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SchedulePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyJourneys(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Favourite(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SuggestedItinerary(),
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
