import 'package:flutter/material.dart';
import '../model/user_preference.dart';
import '../model/user.dart';
import '../widget/profile_widget.dart';
import '../widget/textfield_widget.dart';

//import 'package:user_profile_example/widget/button_widget.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user = UserPreferences.myUser;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Full Name',
              text: user.name,
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Age',
              text: user.age.toString(),
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
