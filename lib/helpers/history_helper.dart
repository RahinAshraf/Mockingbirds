import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/services/user_services.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/location_service.dart';

///Helper functions to add,delete or retrieve docking stations
///from and to the firestore database for a user
///@author Tayyibah

class HistoryHelper {
  late CollectionReference _history;
  late final _user_id;
  late FirebaseFirestore _db;

  HistoryHelper() {
    _db = FirebaseFirestore.instance;
    _user_id = FirebaseAuth.instance.currentUser!.uid;

    _history = _db.collection('users').doc(_user_id).collection('history');
  }

  static void test(List<List<double?>?> list) async {
    LocationService service = new LocationService();

    print("HEREEEEEEEEEEE");
    print(list);
    List<double?> destination;
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        var item = list[i];
        //service.reverseGeoCode(item[0], item[1]);
        // myList.add(LatLng(points[i]?.first as double, points[i]?.last as double));
        Map map = await service.reverseGeoCode(
            list[i]?.first as double, list[i]?.last as double);

        print(map["name"]);
      }
    }
  }
  // Future<void> addJourney(
  //   double ,
  // ) {
  //   return _favourites
  //       .add({
  //         'stationId': stationId,
  //         'name': name,
  //         'numberOfBikes': numberOfBikes,
  //         'numberOfEmptyDocks': numberOfEmptyDocks,
  //       })
  //       .then((value) => print("fave Added"))
  //       .catchError((error) =>
  //           print("Failed to add fave: $error")); //add snackbar instead
  // }

//   Future<void> deleteFavourite(favouriteDocumentId) {
//     return _favourites
//         .doc(favouriteDocumentId)
//         .delete()
//         .then((value) => print(favouriteDocumentId))
//         .catchError((error) => print("Failed to delete fave: $error"));
//   }

//   static Future<List<DockingStation>> getUserFavourites() async {
//     List<DockingStation> favourites = [];
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     QuerySnapshot<Object?> docs = await db
//         .collection('users')
//         .doc(getUid())
//         .collection('favourites')
//         .get();
//     for (DocumentSnapshot doc in docs.docs) {
//       favourites.add(DockingStation.map(doc));
//     }
//     return favourites;
//   }

// //Deletes every single favourite documents, maybe move this to settings?
//   Future deleteUsersFavourites() async {
//     var snapshots = await _favourites.get();
//     for (var doc in snapshots.docs) {
//       await doc.reference.delete();
//     }
//   }

//   bool isFavouriteStation(
//       String stationId, List<DockingStation> favouriteList) {
//     DockingStation? station = favouriteList
//         .firstWhereOrNull((DockingStation f) => (f.stationId == stationId));
//     if (station == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   void toggleFavourite(String stationId, String name, int numberOfBikes,
//       int numberOfEmptyDocks) async {
//     var favouriteList = await getUserFavourites();
//     if (isFavouriteStation(stationId, favouriteList)) {
//       DockingStation favouriteStation = favouriteList
//           .firstWhere((DockingStation f) => (f.stationId == stationId));
//       String? favouriteDocumentId = favouriteStation.documentId;
//       await deleteFavourite(favouriteDocumentId);
//     } else {
//       await addFavourite(stationId, name, numberOfBikes, numberOfEmptyDocks);
//     }
//   }
}
