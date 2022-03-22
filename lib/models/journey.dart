import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'docking_station.dart';
import '../helpers/navigation_helpers/navigation_conversion_helpers.dart';

///Represents a journey which is made up of list of docking stations
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

  Journey.map(DocumentSnapshot document, List<DockingStation> stationList) {
    _journeyDocumentId = document.id;
    _date = document.get('date');
    _stationList = stationList;
  }

  Journey.mapDates(DocumentSnapshot document) {
    var geoList = document.get('points');

    List<List<double>> tempList = [];
    for (int i = 0; i < geoList.length; i++) {
      tempList.add([geoList[i].latitude, geoList[i].longitude]);
    }
    _myDestinations = convertListDoubleToLatLng(tempList);
    _journeyDocumentId = document.id;
    var timeStamp = document.get('date');
    _date = timeStamp.toDate();
    _numberOfCyclists = document.get('numberOfCyclists');
  }
}
