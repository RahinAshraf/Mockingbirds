import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/models/docking_station.dart';

///Represents a journey which is made up of list of docking stations and/or destinations.
///Author: Tayyibah, Nicole

class Itinerary {
  String? _journeyDocumentId;
  List<LatLng>? _myDestinations = [];
  List<DockingStation>? _docks = []; //list of docking stations in a journey
  DateTime? _date; //time journey starts/is planned to start
  int? _numberOfCyclists;
  Itinerary.navigation(
      this._docks, this._myDestinations, this._numberOfCyclists) {
    Random rand = Random();
    _date = DateTime.now();
    _journeyDocumentId = rand.nextInt(100).toString();
  }

  DateTime? get date => _date;
  String? get journeyDocumentId => _journeyDocumentId;
  List<DockingStation>? get docks => _docks;
  List<LatLng>? get myDestinations => _myDestinations;
  int? get numberOfCyclists => _numberOfCyclists;

  ///Creates a journey from firebase when a journey has started,
  ///to include its document id, list of docking stations and start time.

  Itinerary.map(DocumentSnapshot document, List<DockingStation> stationList) {
    _journeyDocumentId = document.id;
    _date = (document.get('date')).toDate();
    _docks = stationList;
  }
  Itinerary.suggestedTrip(
      List<LatLng> _myDest, String str, List<String> bikePoints) {
    _myDestinations = _myDest;
    _journeyDocumentId = str;

    for (int i = 0; i < bikePoints.length; i++) {
      updateDock(bikePoints[i]);
    }
  }

  ///Creates a scheduled journey from firebase to include its planned date, document id
  ///and list of destinations
  Itinerary.scheduleMap(DocumentSnapshot document) {
    var geoList = document.get('points');

    List<List<double>> tempList = [];
    for (int i = 0; i < geoList.length; i++) {
      tempList.add([geoList[i].latitude, geoList[i].longitude]);
    }

    _myDestinations = convertListDoubleToLatLng(tempList);
    _journeyDocumentId = document.id;
    _date = (document.get('date')).toDate();
    _numberOfCyclists = document.get('numberOfCyclists');
    updateDocks();
  }

  // checks the information of only one docking station, useful for suggested journeys
  void updateDock(String id) async {
    dockingStationManager _stationManager = dockingStationManager();
    var tempDock = await _stationManager.checkStationById(id);
    _docks!.add(tempDock!);
  }

  void updateDocks() async {
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    for (int i = 0; i < myDestinations!.length; i++) {
      if (i == 0) {
        _docks!.add(_stationManager.getClosestDockWithAvailableBikes(
            myDestinations![i], numberOfCyclists!));
      } else {
        _docks!.add(_stationManager.getClosestDockWithAvailableSpace(
            myDestinations![i], numberOfCyclists!));
      }
    }
  }

  void setDocks(List<DockingStation> inputDocks) {
    _docks = inputDocks;
  }
}
