import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/itinerary.dart';

///Helper functions to add or remove a scheduled itinerary from the database.
///An itinerary includes a list of destinations and the time the trip should start.
///Author: Tayyibah
class ScheduleHelper {
  late CollectionReference _schedules;
  late final _user_id;
  late FirebaseFirestore _db;

  ScheduleHelper() {
    _db = FirebaseFirestore.instance;
    _user_id = FirebaseAuth.instance.currentUser!.uid;
    _schedules = _db.collection('users').doc(_user_id).collection('schedules');
  }

  void createScheduleEntry(DateTime scheduleDate, List<List<double?>?> points,
      int numberOfCyclists) {
    List<GeoPoint> geoList = [];
    for (int i = 0; i < points.length; i++) {
      geoList.add(GeoPoint(points[i]![0]!, points[i]![1]!));
    }

    _schedules.doc().set({
      'date': scheduleDate,
      'points': geoList,
      'numberOfCyclists': numberOfCyclists,
    });
  }

  ///Gets all of a users schedules
  Future<List<Itinerary>> getAllScheduleDocuments() async {
    List<Itinerary> scheduleList = [];
    QuerySnapshot<Object?> journeys = await _schedules.get();
    for (DocumentSnapshot doc in journeys.docs) {
      scheduleList.add(Itinerary.scheduleMap(doc));
    }
    return scheduleList;
  }
}
