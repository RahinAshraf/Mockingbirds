import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../screens/change_password_screen.dart';
import '../../helpers/database_helpers/settings_helper.dart';

/// Settings screen where user can log out, change their password or delete their account.
/// Author(s): Tayyibah Uddin, Eduard Ragea

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  /// Deletes user's account by deleting first the documents in the journeys and schedules
  /// subcollections.
  /// Show a popup to confirm deletion by re-entering password
  void deleteAccount(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    final defaultProfilePictureURL =
        'https://firebasestorage.googleapis.com/v0/b/veloplan-b41d0.appspot.com/o/user_image%2Fdefault_profile_picture.jpg?alt=media&token=edc6abb8-3655-448c-84a0-7d34b02f0c73';
    showDialog(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            title: const Text('Please confirm your password'),
            content: TextFormField(
              obscureText: true,
              controller: passwordController,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final isReauthenticated =
                        await checkCurrentPassword(passwordController.text);
                    if (isReauthenticated) {
                      try {
                        final userID = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseAuth.instance.currentUser!.delete();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userID)
                            .collection('journeys')
                            .get()
                            .then((snapshot) async {
                          for (DocumentSnapshot documentSnapshot
                              in snapshot.docs) {
                            await documentSnapshot.reference
                                .collection('docking_stations')
                                .get()
                                .then((snapshotDockingStation) async {
                              for (DocumentSnapshot documentSnapshot
                                  in snapshotDockingStation.docs) {
                                await documentSnapshot.reference.delete();
                              }
                            });
                            await documentSnapshot.reference.delete();
                          }
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userID)
                            .collection('schedules')
                            .get()
                            .then((snapshot) async {
                          for (DocumentSnapshot documentSnapshot
                              in snapshot.docs) {
                            await documentSnapshot.reference.delete();
                          }
                        });
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "An error has occured, please check your password and try again"),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  child: const Text('Done')),
              TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                  },
                  child: const Text('Back'))
            ],
          );
        });
  }

  /// Push the ChangePasswordScreen on top of the widget stack
  /// and show a confirmation snackbar in case the password was
  /// succesfully changed.
  void changePassword(context) async {
    var result = await Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => ChangePasswordScreen())));
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your password has been successfully updated"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(key: Key("back"), color: Colors.white),
          title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            key: Key("logOut"),
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            key: Key("changePassword"),
            leading: const Icon(Icons.password),
            title: const Text('Change password'),
            onTap: () => changePassword(context),
          ),
          ListTile(
            key: Key("deleteAccount"),
            leading: const Icon(Icons.delete),
            title: const Text('Delete account'),
            onTap: () => deleteAccount(context),
          ),
        ],
      ),
    );
  }
}
