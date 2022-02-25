import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/profile_widget.dart';
import '../widget/textfield_widget.dart';

//import 'package:user_profile_example/widget/button_widget.dart';

class EditProfile extends StatefulWidget {
  final Map<String,dynamic> data;
  const EditProfile(this.data, {Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = FirebaseAuth.instance.currentUser!.uid;
  var _firstName = '';
  var _lastName = '';
  var _username = '';

  void _submitChanges() {

  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              Navigator.of(context).pop();
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
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(widget.data['image_url'], () async {}, true 
            ),
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
      );
}

// Widget buildStatisticsButton() => ButtonWidget(
//       text: 'Statistics',
//       onClicked: () {},
//     );
