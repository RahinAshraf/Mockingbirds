import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../providers/docking_station_manager.dart';
import 'docking_station.dart';

///Represents a journey which is made up of list of docking stations and/or destinations.
///Author: Tayyibah

class Itinerary {
  String? _journeyDocumentId;
  List<LatLng>? _myDestinations = [];
  List<DockingStation>? _docks = []; //list of docking stations in a journey
  DateTime? _date; //time journey starts/is planned to start
  int? _numberOfCyclists;
  Itinerary.navigation(
      this._docks, this._myDestinations, this._numberOfCyclists);

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
