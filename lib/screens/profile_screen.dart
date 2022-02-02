import 'package:flutter/material.dart';
import '../model/user_preference.dart';
import '../model/user.dart';
import '../widget/profile_widget.dart';
//import 'package:user_profile_example/widget/button_widget.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.age,
            style: TextStyle(color: Colors.grey),
          ),
          // const SizedBox(height: 24),
          // Center(child: buildStatisticsButton()),
        ],
      );
}

// Widget buildStatisticsButton() => ButtonWidget(
//       text: 'Statistics',
//       onClicked: () {},
//     );
