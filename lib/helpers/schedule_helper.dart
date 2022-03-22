import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/journey.dart';
import 'package:intl/intl.dart';

///Helper functions to add or remove a journey from the database.
///A journey comprises of a list of docking stations and the time the journey was started.
///Author: Tayyibah
class ScheduleHelper {
  late CollectionReference _journeys;
  late final _user_id;
  late FirebaseFirestore _db;

  ScheduleHelper() {
    _db = FirebaseFirestore.instance;
    _user_id = FirebaseAuth.instance.currentUser!.uid;
    _journeys =
        _db.collection('users').doc(_user_id).collection('future_journeys');
  }

  ///Creates a new journey entry and adds the time and docking stations
  void createJourneyEntry(
      DateTime journeyDate, List<List<double?>?> points, int numberOfCyclists) {
    var newJourney = _journeys.doc();
    addJourneyTime(newJourney.id, journeyDate, points, numberOfCyclists);
  }

  ///Calculates the date and adds as a field to journey
  void addJourneyTime(journeyDocumentId, DateTime journeyDate,
      List<List<double?>?> points, int numberOfCyclists) {
    List<GeoPoint> geoList = [];
    for (int i = 0; i < points!.length; i++) {
      geoList.add(GeoPoint(points[i]![0]!, points[i]![1]!));
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedTime = formatter.format(journeyDate);
    _journeys.doc(journeyDocumentId).set({
      'date': journeyDate,
      'points': geoList,
      'numberOfCyclists': numberOfCyclists,
    });
  }

  ///Gets all of a users journeys
  Future<List<Journey>> getAllJourneyDocuments() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Journey> journeyList = [];

    QuerySnapshot<Object?> journeys = await _journeys.get();
    for (DocumentSnapshot doc in journeys.docs) {
      journeyList.add(Journey.mapDates(doc));
    }
    return journeyList;
  }

  ///Deletes docking station subcollection and then deletes journey entry
  ///from the database.
  void deleteJourneyEntryWithDockingStations(String journeyDocumentId) async {
    deleteDockingStations(journeyDocumentId);
    deleteJourneyEntry(journeyDocumentId);
  }

  ///Deletes docking station subcollection from a given journey.
  void deleteDockingStations(String journeyDocumentId) async {
    var dockingStations =
        _journeys.doc(journeyDocumentId).collection("docking_stations");

    QuerySnapshot<Object?> dockingStationDocuments =
        await dockingStations.get();

    for (DocumentSnapshot doc in dockingStationDocuments.docs) {
      dockingStations.doc(doc.id).delete();
    }
  }

  ///Deletes a given journey
  void deleteJourneyEntry(String journeyDocumentId) {
    _journeys
        .doc(journeyDocumentId)
        .delete()
        .then((value) => print("deleted"))
        .catchError((error) => print("Failed to delete journey: $error"));
  }
}
// static Future<List<DockingStation>> getUserFavourites() async {
//   List<DockingStation> favourites = [];
//   FirebaseFirestore db = FirebaseFirestore.instance;

//   QuerySnapshot<Object?> docs = await db
//       .collection('users')
//       .doc(getUid())
//       .collection('favourites')
//       .get();
//   for (DocumentSnapshot doc in docs.docs) {
//     favourites.add(DockingStation.map(doc));
//   }
//   return favourites;
// }

///TO DO:
///for each journey a user has we want to get the docking stations and add it to a card
///add it to a carousel
///view a carousel for each journey
///
///

// static void test(List<List<double?>?> list) async {
//   LocationService service = new LocationService();

//   print("HEREEEEEEEEEEE");
//   print(list);
//   List<double?> destination;
//   if (list != null) {
//     for (int i = 0; i < list.length; i++) {
//       var item = list[i];
//       //service.reverseGeoCode(item[0], item[1]);
//       // myList.add(LatLng(points[i]?.first as double, points[i]?.last as double));
//       Map map = await service.reverseGeoCode(
//           list[i]?.first as double, list[i]?.last as double);

//       print(map["name"]);
//     }
//   }
// }
