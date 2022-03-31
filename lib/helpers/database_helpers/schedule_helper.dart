import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/itinerary.dart';

/// Helper functions to add or remove a scheduled itinerary from the database.
/// An itinerary includes a list of destinations and the time the trip should start.
/// Author: Tayyibah
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

  /// Checks for and deletes user's expired trips from the database.
  Future<void> deleteOldScheduledEntries() async {
    var entries = await _schedules.get();
    entries.docs.forEach((element) {
      DateTime date = element.get('date').toDate();
      if (DateUtils.dateOnly(DateTime.now()).isAfter(date)) {
        element.reference.delete();
      }
    });
  }

  /// Deletes a single scheduled entry from database.
  Future<void> deleteSingleScheduledEntry(Itinerary entry) async {
    _schedules.doc(entry.journeyDocumentId!).delete();
  }

  /// Retrieves all user's schedules.
  Future<List<Itinerary>> getAllScheduleDocuments() async {
    List<Itinerary> scheduleList = [];
    QuerySnapshot<Object?> journeys = await _schedules.get();
    for (DocumentSnapshot doc in journeys.docs) {
      scheduleList.add(Itinerary.scheduleMap(doc));
    }
    return scheduleList;
  }
}
