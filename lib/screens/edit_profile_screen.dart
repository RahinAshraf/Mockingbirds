import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/profile/profile_widget.dart';
import '../widgets/textfield_widget.dart';

//import 'package:user_profile_example/widget/button_widget.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditProfile(this.data, {Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  var _firstName = '';
  var _lastName = '';
  var _username = '';

  Future<bool> _checkUsernameIsFree() async {
    if (_username == widget.data['username']) {
      return true;
    }
    return (await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _username)
            .get())
        .docs
        .isEmpty;
  }

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
          await FirebaseFirestore.instance.collection('users').doc(userID).set({
            if (_firstName != '') 'firstName': _firstName,
            if (_lastName != '') 'lastName': _lastName,
            if (_username != '') 'username': _username
          }, SetOptions(merge: true));
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
              label: 'First Name',
              text: widget.data['firstName'],
              onChanged: (firstName) {
                _firstName = firstName;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Last Name',
              text: widget.data['lastName'],
              onChanged: (lastName) {
                _lastName = lastName;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
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
