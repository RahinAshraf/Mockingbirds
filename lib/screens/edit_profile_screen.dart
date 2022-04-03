import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/profile/profile_widget.dart';
import '../widgets/textfield_widget.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/widgets/profile/profile_widget.dart';
import 'package:veloplan/widgets/textfield_widget.dart';

/// Screen for the editing current users's profile
/// Author(s): Eduard Ragea k20067643
class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditProfile(this.data, {Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final DatabaseManager _databaseManager = DatabaseManager();
  late final userID = _databaseManager.getCurrentUser()!.uid;
  var _firstName = '';
  var _lastName = '';
  var _username = '';

  /// Check with Firebase if the chosen username
  /// is not taken.
  Future<bool> _checkUsernameIsFree() async {
    if (_username == widget.data['username']) {
      return true;
    }
    return (await _databaseManager.getByEquality(
            'users', 'username', _username))
        .docs
        .isEmpty;
  }

  /// Check for already used username. If it is not valid show
  /// snackbar, otherwise update the user's document on Firebase.
  /// Handle error by showing a snackbar with the message.
  void _submitChanges() {
    try {
      _checkUsernameIsFree().then((value) async {
        if (!value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'This username is already taken! Please choose something else.'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          return;
        } else {
          await _databaseManager.setByKey(
              'users',
              userID,
              {
                if (_firstName != '') 'firstName': _firstName,
                if (_lastName != '') 'lastName': _lastName,
                if (_username != '') 'username': _username
              },
              SetOptions(merge: true));
          Navigator.of(context).pop();
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Show a dialog to rpevent losing progress on accidental exit.
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are you sure want to leave?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          willLeave = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'))
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          key: Key("appBarNameEditProfile"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          elevation: 0,
          title: const Text('Edit profile'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _submitChanges();
                },
                child: const Icon(
                  Icons.check,
                  key: Key("confirmEditProfile"),
                  size: 26.0,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(widget.data['image_url'], () async {}, true),
            const SizedBox(height: 24),
            TextFieldWidget(
              key: Key("firstNameEditP"),
              label: 'First Name',
              text: widget.data['firstName'],
              onChanged: (firstName) {
                _firstName = firstName;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              key: Key("lastNameEditP"),
              label: 'Last Name',
              text: widget.data['lastName'],
              onChanged: (lastName) {
                _lastName = lastName;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              key: Key("usernameNameEditP"),
              label: 'Username',
              text: widget.data['username'],
              onChanged: (username) {
                _username = username;
              },
            ),
          ],
        ),
      ),
    );
  }
}
