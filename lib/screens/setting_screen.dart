import 'package:flutter/material.dart';
import '../styles/styling.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: appBarColor,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onPressed: (BuildContext context) {
                  FirebaseAuth.instance.signOut();
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Switch mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLogout() => SimpleSettingsTile(
      title: 'Logout',
      leading: Icon(Icons.logout),
      onTap: () => FirebaseAuth.instance.signOut());
}
//check for push

// Widget buildSettingsList() {
//   return ListView(
//     children: <Widget>[
//       const SizedBox(height: 48),
//       buildMenuItem(
//         text: 'Log Out',
//         icon: Icons.logout,
//         onClicked: () => FirebaseAuth.instance.signOut(),
//       ),
//     ],
//   );
// }

// Widget buildMenuItem({
//   required String text,
//   required IconData icon,
//   VoidCallback? onClicked,
// }) {
//   final color = Colors.green;

//   return ListTile(
//     leading: Icon(icon),
//     title: Text(text, style: TextStyle(color: color)),
//     onTap: onClicked,
//   );
// }


// Center(
//         child: ListTile(
//           leading: Icon(Icons.logout),
//           title: Text("Log Out", style: TextStyle(color: Colors.green)),
//           onTap: () => FirebaseAuth.instance.signOut(),
//         ),
//       ),
