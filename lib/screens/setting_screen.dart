import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles/config.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: buildSettings(),
    );
  }

  Widget buildSettings() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Account'),
          tiles: <SettingsTile>[
            buildLogout(),
            buildDarkMode(),
          ],
        ),
      ],
    );
  }

  SettingsTile buildLogout() => SettingsTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onPressed: (BuildContext context) {
          FirebaseAuth.instance.signOut();
        },
      );

  SettingsTile buildDarkMode() => SettingsTile.switchTile(
        onToggle: (bool value) {
          currentTheme.toggleTheme();
        },
        initialValue: false,
        leading: const Icon(Icons.dark_mode),
        title: const Text('Dark mode'),
      );
}
