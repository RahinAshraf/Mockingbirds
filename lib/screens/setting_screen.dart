import 'package:flutter/material.dart';
import '../styles/theme.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: buildSettings(),
    );
  }

  Widget buildSettings() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Account'),
          tiles: <SettingsTile>[
            buildLogout(),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Switch mode'),
            ),
          ],
        ),
      ],
    );
  }

  SettingsTile buildLogout() => SettingsTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onPressed: (BuildContext context) {
          FirebaseAuth.instance.signOut();
        },
      );
}
