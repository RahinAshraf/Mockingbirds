/// Helpers for interacting with statistics
/// Author(s): Eduard Ragea k20067643

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/helpers/live_location_helper.dart';

Future updateDistanceOnServer(userID) async {
  await FirebaseFirestore.instance.collection('users').doc(userID).update({
    'distance':
        FieldValue.increment(sharedPreferences.getDouble('distance') ?? 0)
  });
  sharedPreferences.clear();
}
