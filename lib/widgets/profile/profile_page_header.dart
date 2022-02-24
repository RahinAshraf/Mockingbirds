import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/widget/profile_widget.dart';

class ProfilePageHeader extends StatefulWidget {
  Map<String, dynamic> data;

  ProfilePageHeader(this.data, {Key? key}) : super(key: key);

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
        padding:
            const EdgeInsets.only(top: 10, bottom: 20),
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
              margin: EdgeInsets.symmetric(horizontal: 20),
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
                    imagePath: widget.data['image_url'],
                    onClicked: () async {},
                  ),
                  const SizedBox(height: 24),
                  buildName(widget.data),
                  buildCyclingHistory(widget.data),
                ],
              ),
            );
  }
}
