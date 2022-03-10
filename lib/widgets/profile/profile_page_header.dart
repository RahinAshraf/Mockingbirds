import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/widgets/profile/profile_widget.dart';

class ProfilePageHeader extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isCurrentUser;

  const ProfilePageHeader(this.data, this.isCurrentUser, {Key? key})
      : super(key: key);

  @override
  _ProfilePageHeaderState createState() => _ProfilePageHeaderState();
}

class _ProfilePageHeaderState extends State<ProfilePageHeader> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  String calculateAge(Timestamp birthDateTimestamp) {
    DateTime currentDate = DateTime.now();
    DateTime birthDate = birthDateTimestamp.toDate();
    int age = currentDate.year - birthDate.year;
    int currentMonth = currentDate.month;
    int birthMonth = birthDate.month;
    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = currentDate.day;
      int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age.toString();
  }

  Widget buildName(Map<String, dynamic> data) => Column(
        children: [
          Text(
            '${data['firstName']} ${data['lastName']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            data['email'],
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            calculateAge(data['birthDate']),
            style: const TextStyle(color: Colors.grey),
          ),
          // const SizedBox(height: 24),
        ],
      );

  Widget buildCyclingHistory(Map<String, dynamic> data) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '10',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Kilometers',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '18',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Journeys',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              width: 11,
            ),
          ],
        ),
      );

  Widget buildButtons() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: widget.isCurrentUser
            ? ElevatedButton(
                onPressed: () {},
                child: const Text('Edit Profile'),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Follow'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Message'),
                  )
                ],
              ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          ProfileWidget(
            widget.data['image_url'],
            () async {},
            widget.isCurrentUser,
          ),
          const SizedBox(height: 24),
          buildName(widget.data),
          buildCyclingHistory(widget.data),
          // buildButtons(),
        ],
      ),
    );
  }
}
