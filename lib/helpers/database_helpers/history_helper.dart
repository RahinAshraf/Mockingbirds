import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/docking_station.dart';
import '../../models/itinerary.dart';
import '../../providers/docking_station_manager.dart';
import 'database_manager.dart';

///Helper functions to add started journeys to data base.
///Started journeys include a list of docking stations and the time the journey began.
///Author: Tayyibah

class HistoryHelper {
  late CollectionReference _journeys;
  DatabaseManager _databaseManager = DatabaseManager();

  HistoryHelper(this._databaseManager) {
    _journeys = _databaseManager.getUserSubCollectionReference("journeys");
  }

  ///Creates a new journey entry and adds the time and docking stations
  void createJourneyEntry(List<DockingStation> dockingStationList) {
    var newJourney = _journeys.doc();
    addJourneyTime(newJourney.id);
    for (DockingStation station in dockingStationList) {
      addDockingStation(station, newJourney.id);
    }
  }

  Future<void> addDockingStation(
    DockingStation station,
    documentId,
  ) {
    return _databaseManager.addSubCollectiontoSubCollectionByDocumentId(
        documentId, "docking_stations", _journeys, {
      'stationId': station.stationId,
    });
  }

  Future<void> addJourneyTime(journeyDocumentId) {
    final DateTime timeNow = DateTime.now();
    return _databaseManager.setSubCollectionByDocumentId(
      journeyDocumentId,
      _journeys,
      {'date': timeNow},
    );
  }

  ///Gets all of the docking station information from a given journey
  Future<List<DockingStation>> getDockingStationsInJourney(
      journeyDocumentId) async {
    List<DockingStation> stationsInJourney = [];

    var list = await _databaseManager.getDocumentsFromSubCollection(
      _journeys,
      journeyDocumentId,
      'docking_stations',
    );

    for (DocumentSnapshot doc in list.docs) {
      if (doc != null) {
        var dock = await dockingStationManager()
            .checkStationById(doc.get('stationId'))
            .then((value) {
          stationsInJourney.add(DockingStation.map(doc, value!));
        });
      }
    }
    return stationsInJourney;
  }

  ///Gets all of a users journeys
  Future<List<Itinerary>> getAllJourneyDocuments() async {
    List<Itinerary> journeyList = [];
    var journeys = await _journeys.get();
    for (DocumentSnapshot doc in journeys.docs) {
      List<DockingStation> stationList =
          await getDockingStationsInJourney(doc.id);
      journeyList.add(Itinerary.map(doc, stationList));
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
    _databaseManager.deleteDocument(_journeys, journeyDocumentId);
  }
}
