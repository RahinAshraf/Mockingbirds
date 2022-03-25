import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/docking_station.dart';
import '../../models/journey.dart';
import 'database_manager.dart';

///Helper functions to add started journeys to data base.
///Started journeys include a list of docking stations and the time the journey began.
///Author: Tayyibah

class HistoryHelper {
  late CollectionReference _journeys;
  DatabaseManager databaseManager = DatabaseManager();

  HistoryHelper() {
    _journeys = databaseManager.getUserSubCollectionReference("journeys");
  }

  ///Creates a new journey entry and adds the time and docking stations
  void createJourneyEntry(List<DockingStation> dockingStationList) {
    var newJourney = _journeys.doc();
    addJourneyTime(newJourney.id);
    for (DockingStation station in dockingStationList) {
      addDockingStation(station, newJourney.id);
    }
  }

  ///Adds a docking station subcollection to a given journey
  Future<void> addDockingStation(
    DockingStation station,
    documentId,
  ) {
    return _journeys
        .doc(documentId)
        .collection('docking_stations')
        .add({
          'stationId': station.stationId,
          'name': station.name,
          'numberOfBikes': station
              .numberOfBikes, //these will be removed and changed to lat and lng
          'numberOfEmptyDocks': station.numberOfEmptyDocks,
        })
        .then((value) => print("docking station Added"))
        .catchError((error) =>
            print("Failed to add docking station to journey: $error"));
  }

  ///Calculates the current date and adds as a field to journey
  Future<void> addJourneyTime(journeyDocumentId) {
    final DateTime timeNow = DateTime.now();
    return _journeys.doc(journeyDocumentId).set({'date': timeNow});
  }

  ///Gets all of the docking station information from a given journey
  Future<List<DockingStation>> getDockingStationsInJourney(
      journeyDocumentId) async {
    List<DockingStation> stationsInJourney = [];

    var list = await _journeys
        .doc(journeyDocumentId)
        .collection('docking_stations')
        .get();

    for (DocumentSnapshot doc in list.docs) {
      stationsInJourney.add(DockingStation.map(doc));
    }

    return stationsInJourney;
  }

  ///Gets all of a users journeys
  Future<List<Journey>> getAllJourneyDocuments() async {
    List<Journey> journeyList = [];

    var journeys = await _journeys.get();
    for (DocumentSnapshot doc in journeys.docs) {
      List<DockingStation> stationList =
          await getDockingStationsInJourney(doc.id);
      journeyList.add(Journey.map(doc, stationList));
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
    databaseManager.deleteDocument(_journeys, journeyDocumentId);
  }
}
