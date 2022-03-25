import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'docking_station.dart';

///Represents a journey which is made up of list of docking stations and/or destinations.
///Author: Tayyibah

class Journey {
  String? _journeyDocumentId;
  List<LatLng>? _myDestinations = [];
  late List<DockingStation>?
      _stationList; //list of docking stations in a journey
  DateTime? _date; //time journey starts/is planned to start
  int? _numberOfCyclists;
  Journey(this._journeyDocumentId, this._stationList, this._date);

  DateTime? get date => _date;
  String? get journeyDocumentId => _journeyDocumentId;
  List<DockingStation>? get stationList => _stationList;
  int? get numberOfCyclists => _numberOfCyclists;

  ///Creates a journey from firebase when a journey has started,
  ///to include its document id, list of docking stations and start time.

  Journey.map(DocumentSnapshot document, List<DockingStation> stationList) {
    _journeyDocumentId = document.id;
    _date = (document.get('date')).toDate();
    _stationList = stationList;
  }

  ///Creates a scheduled journey from firebase to include its planned date, document id
  ///and list of destinations
  Journey.scheduleMap(DocumentSnapshot document) {
    var geoList = document.get('points');

    List<List<double>> tempList = [];
    for (int i = 0; i < geoList.length; i++) {
      tempList.add([geoList[i].latitude, geoList[i].longitude]);
    }

    _myDestinations = convertListDoubleToLatLng(tempList);
    _journeyDocumentId = document.id;
    _date = (document.get('date')).toDate();
    _numberOfCyclists = document.get('numberOfCyclists');
  }
}
