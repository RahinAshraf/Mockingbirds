import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/itinerary.dart';
import 'dart:math' as math;
import '../../models/docking_station.dart';
import '../navigation_helpers/navigation_conversions_helpers.dart';
import 'database_manager.dart';

/// Author: Lilianna
class groupManager {
  late DatabaseManager _databaseManager;

  groupManager(this._databaseManager) {}

  Future<void> deleteOldGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    if (user.data() != null) {
      var hasGroup = user.data()!.keys.contains('group');
      if (hasGroup) {
        var group = await _databaseManager.getByEquality(
            'group', 'code', user.data()!['group']);
        group.docs.forEach((element) {
          Timestamp timestamp = element.data()['createdAt'];
          var memberList = element.data()['memberList'];
          if (DateTime.now().difference(timestamp.toDate()) >
              Duration(days: 2)) {
            element.reference.delete();
            for (String member in memberList) {
              _databaseManager.setByKey('users', member,
                  {'group': FieldValue.delete()}, SetOptions(merge: true));
            }
          }
        });
      }
    }
  }

  Future<void> createGroup(Itinerary _itinerary) async {
    var ownerID = _databaseManager.getCurrentUser()?.uid;
    List list = [];
    list.add(ownerID);
    math.Random rng = math.Random();
    String code = rng.nextInt(999999).toString();
    code = _padWithZeroes(code);
    var x = await _databaseManager.getByEquality('group', 'code', code);
    while (x.size != 0) {
      code = rng.nextInt(999999).toString();
      code = _padWithZeroes(code);

      x = await _databaseManager.getByEquality('group', 'code', code);
    }
    List<GeoPoint> geoList = [];
    if (_itinerary.myDestinations != null) {
      var destinationsIndouble =
          convertLatLngToDouble(_itinerary.myDestinations!);
      for (int i = 0; i < destinationsIndouble!.length; i++) {
        geoList.add(GeoPoint(
            destinationsIndouble[i]![0]!, destinationsIndouble[i]![1]!));
      }
      await _databaseManager.setByKey(
          'users', ownerID!, {'group': code}, SetOptions(merge: true));
      var group = await _databaseManager.addToCollection('group', {
        'code': code,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      var journey = await group.collection("itinerary").add({
        'journeyID': _itinerary.journeyDocumentId,
        'points': geoList,
        'date': _itinerary.date,
        'numberOfCyclists': _itinerary.numberOfCyclists
      });
      var dockingStationList = _itinerary.docks!;
      for (int j = 0; j < geoList.length; j++) {
        var geo = geoList[j];
        _databaseManager.addToSubCollection(journey.collection("coordinates"), {
          'coordinate': geo,
          'index': j,
        });
      }
      for (int i = 0; i < dockingStationList.length; i++) {
        var station = dockingStationList[i];
        _databaseManager
            .addToSubCollection(journey.collection("dockingStations"), {
          'id': station.stationId,
          'name': station.name,
          'location': GeoPoint(station.lat, station.lon),
          'index': i,
        });
      }
    }
  }

  String getGroupOwner(QuerySnapshot<Map<String, dynamic>> group) {
    var tempr;
    group.docs.forEach((element) {
      tempr = element.data()['ownerID'];
    });
    return tempr;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGroupOwnerRef(
      QuerySnapshot<Map<String, dynamic>> group) {
    var tempr;
    group.docs.forEach((element) {
      tempr = _databaseManager.getByKey('users', element.data()['ownerID']);
    });
    return tempr;
  }

  Future<String> leaveGroup(String groupID) async {
    var groupResponse =
        await _databaseManager.getByEquality('group', 'code', groupID);
    var userID = _databaseManager.getCurrentUser()?.uid;
    var ownerID;
    List list = [];
    for (var element in groupResponse.docs) {
      ownerID = getGroupOwner(groupResponse);
      list = element.data()['memberList'];
      list.removeWhere((element) => (element == userID));
      if (list.isEmpty) {
        element.reference.delete();
      } else {
        if (ownerID == userID) {
          _databaseManager
              .updateByKey('group', element.id, {'ownerID': list[0]});
        }
        _databaseManager.updateByKey('group', element.id, {'memberList': list});
      }
      await _databaseManager
          .updateByKey('users', userID!, {'group': FieldValue.delete()});
    }
    return ownerID;
  }

  Future<Itinerary> joinGroup(String code) async {
    Itinerary _itinerary;
    var group = await _databaseManager.getByEquality('group', 'code', code);
    var list = [];
    _itinerary = await getItineraryFromGroup(group);
    String id = "";
    group.docs.forEach((element) async {
      id = element.id;
      list = element.data()['memberList'];
      list.add(_databaseManager.getCurrentUser()?.uid);
      _databaseManager.setByKey('users', _databaseManager.getCurrentUser()!.uid,
          {'group': element.data()['code']}, SetOptions(merge: true));
    });
    await _databaseManager.updateByKey('group', id, {'memberList': list});
    return _itinerary;
  }

  Future<Itinerary> getItineraryFromGroup(
      QuerySnapshot<Map<String, dynamic>> group) async {
    List<DockingStation> _docks = [];
    var geoList = [];
    var _myDestinations;
    var _numberOfCyclists;
    for (var element in group.docs) {
      var itinerary = await element.reference.collection('itinerary').get();
      var journeyIDs = itinerary.docs.map((e) => e.id).toList();
      for (var journeyID in journeyIDs) {
        var journey = await element.reference
            .collection('itinerary')
            .doc(journeyID)
            .get();
        if (journey.data() != null) {
          _numberOfCyclists = journey.data()!['numberOfCyclists'];
          geoList = journey.data()!['points'];
          var stationCollection =
              await journey.reference.collection("dockingStations").get();
          var stationList = stationCollection.docs;
          _docks = List.filled(stationList.length,
              DockingStation("fill", "fill", true, false, -1, -1, -1, 10, 20),
              growable: false);
          for (var station in stationList)
            ({
              _docks[station.data()['index']] = (DockingStation(
                station.data()['id'],
                station.data()['name'],
                true,
                false,
                -1,
                -1,
                -1,
                station.data()['location'].longitude,
                station.data()['location'].latitude,
              ))
            });
          var coordinateCollection =
              await journey.reference.collection("coordinates").get();
          var coordMap = coordinateCollection.docs;
          geoList = List.filled(coordMap.length, GeoPoint(10, 20));
          for (var value in coordMap) {
            geoList[value.data()['index']] = value.data()['coordinate'];
          }
        }
        List<List<double>> tempList = [];
        for (int i = 0; i < geoList.length; i++) {
          tempList.add([geoList[i].latitude, geoList[i].longitude]);
        }

        _myDestinations = convertListDoubleToLatLng(tempList);
      }
    }
    return Itinerary.navigation(_docks, _myDestinations, _numberOfCyclists);
  }

  String _padWithZeroes(String textToPad) {
    while (textToPad.length < 6) {
      textToPad = '0' + textToPad;
    }
    return textToPad;
  }
}
