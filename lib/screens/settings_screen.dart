import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloplan/helpers/theme_provider.dart';

/// Settings screen where user can log out and change theme of the app.
/// @author: Tayyibah
class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  void deleteAccount(BuildContext context) {
    final defaultProfilePictureURL =
        'https://firebasestorage.googleapis.com/v0/b/veloplan-b41d0.appspot.com/o/user_image%2Fdefault_profile_picture.jpg?alt=media&token=edc6abb8-3655-448c-84a0-7d34b02f0c73';
    showDialog(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content:
                const Text('Are you sure you want to delete your account?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      final userID = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseAuth.instance.currentUser!.delete();
                      final snapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userID)
                          .get();
                      final data = snapshot.data();
                      if (data != null) {
                        final imageURL = data['image_url'];
                        if (imageURL != defaultProfilePictureURL) {
                          await FirebaseStorage.instance
                              .refFromURL(imageURL)
                              .delete();
                        }
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userID)
                            .delete();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'requires-recent-login') {
                        print(
                            'The user must reauthenticate before this operation can be executed.');
                      }
                    }
                    Navigator.of(c).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

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
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete account'),
            onTap: () => deleteAccount(context),
          ),
        ],
      ),
    );
  }
}
