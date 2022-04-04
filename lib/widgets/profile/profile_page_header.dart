import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/widgets/profile/profile_widget.dart';

/// Widget for displaying the profile page header
/// Author(s): Eduard Ragea k20067643
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
  double distance = 0;
  int journeys = 0;

  /// This function retrieves the distance from the users document on Firebase
  /// and stores it in the distance variable in kilometers.
  Future getDistance() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    final data = snapshot.data();
    if (data != null && data['distance'] != null) {
      distance = data['distance'] / 1000;
    }
  }

  /// This function retrieves the number of journeys from the users document on Firebase
  /// and stores it in the journeys variable.
  Future getJourneys() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users').doc(user).collection('journeys').get();
    journeys = snapshot.size;
  }

  /// Calculate the age of the user by inputing a Timestamp object.
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

  /// Show a short description of the profile which includes
  /// full name, email and age.
  Widget buildName(Map<String, dynamic> data) => Column(
        children: [
          Text(
            '${data['firstName']} ${data['lastName']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            key: Key("profileName"),
          ),
          const SizedBox(height: 4),
          Text(
            data['email'],
            style: const TextStyle(color: Colors.grey),
            key: Key("profileEmail"),
          ),
          const SizedBox(height: 4),
          Text(
            calculateAge(data['birthDate']),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      );

  /// Show the account statistics(number of kilometers done
  /// and the number of journeys)
  Widget buildCyclingHistory(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: getDistance(),
                  builder: (context, snapshot) {
                    return Text(
                      (distance).toStringAsFixed(2),
                      key: Key('distanceStats'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }),
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
            children: [
              FutureBuilder(
                  future: getJourneys(),
                  builder: (context, snapshot) {
                    return Text(
                      '$journeys',
                      key: Key('journeyStats'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }),
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
  }

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
            key: Key("profileImage"),
          ),
          const SizedBox(height: 24),
          buildName(widget.data),
          buildCyclingHistory(widget.data),
        ],
      ),
    );
  }
}
