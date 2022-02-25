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
  // User user = UserPreferences.myUser;
  final user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
        ),
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
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Last Name',
              text: widget.data['lastName'],
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Username',
              text: widget.data['username'],
              onChanged: (age) {},
            ),
          ],
        ),
      );
}

// Widget buildStatisticsButton() => ButtonWidget(
//       text: 'Statistics',
//       onClicked: () {},
//     );
