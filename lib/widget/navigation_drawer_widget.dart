import 'package:flutter/material.dart';
import '../screens/schedule_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
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
            //decided to remove this, not sure if it
            //const SizedBox(height: 24),
            //Divider(color: Colors.green),
            //const SizedBox(height: 24),
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
          builder: (context) => Placeholder(),
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
          builder: (context) => Placeholder(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Placeholder(),
        ));
        break;
    }
  }
}

//things to go on the side bar:
//history
//stats
//settings ?
//calander
//chatbox
