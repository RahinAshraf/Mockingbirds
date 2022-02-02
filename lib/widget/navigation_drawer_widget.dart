import 'package:flutter/material.dart';

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
              text: 'Calander',
              icon: Icons.date_range,
            ),
            buildMenuItem(
              text: 'Statistics',
              icon: Icons.assessment_outlined,
            ),
            buildMenuItem(
              text: 'Help',
              icon: Icons.chat_bubble_outlined,
            ),
            buildMenuItem(
              text: 'Settings',
              icon: Icons.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.green;

    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyle(color: color)),
      onTap: () {},
    );
  }
}

//things to go on the side bar:
//history
//stats
//settings ?
//calander
//chatbox
