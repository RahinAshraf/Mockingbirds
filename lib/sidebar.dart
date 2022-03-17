import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/widgets/dock_station.dart';
import 'package:veloplan/widgets/carousel/dockings_station_card.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import '../screens/schedule_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/help_screen.dart';

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
      child: Container(
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
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.green;

    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyle(color: color)),
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
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SummaryJourneyScreen(),
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
