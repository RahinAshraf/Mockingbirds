import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // buildLogout(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
          ),
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark mode'),
              onChanged: (val) {
                notifier.toggleTheme();
              },
              value: notifier.isDarkTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettings() {
    return ListView(
      children: [
        // buildLogout(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
        Consumer<ThemeNotifier>(
          builder: (context, notifier, child) => SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            onChanged: (val) {
              notifier.toggleTheme();
            },
            value: notifier.isDarkTheme,
          ),
        ),
      ],
    );
  }

  ListTile buildLogout() => ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          FirebaseAuth.instance.signOut();
        },
      );

  // SwitchListTile buildDarkMode() => SwitchListTile(
  //       onToggle: (bool value) {
  //         currentTheme.toggleTheme();
  //       },
  //       initialValue: false,
  //       leading: const Icon(Icons.dark_mode),
  //       title: const Text('Dark mode'),
  //     );

}
