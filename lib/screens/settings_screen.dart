import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloplan/helpers/theme_provider.dart';

/// Settings screen where user can log out and change theme of the app.
/// @author: Tayyibah
class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 10),
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
          // ListTile(
          //   leading: const Icon(Icons.delete),
          //   title: const Text('Delete account'),
          //   onTap: () async {
          //     try {
          //       await FirebaseAuth.instance.currentUser!.delete();
          //     } on FirebaseAuthException catch (e) {
          //       if (e.code == 'requires-recent-login') {
          //         print(
          //             'The user must reauthenticate before this operation can be executed.');
          //       }
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
