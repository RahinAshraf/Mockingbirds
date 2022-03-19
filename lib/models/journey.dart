import 'package:cloud_firestore/cloud_firestore.dart';
import 'docking_station.dart';

///Represents a journey
///Author: Tayyibah

class Journey {
  String? _journeyDocumentId;
  late List<DockingStation>
      _stationList; //list of docking stations in a journey
  String? _time;
  Journey(this._journeyDocumentId, this._stationList, this._time);

  String? get time => _time;
  String? get journeyDocumentId => _journeyDocumentId;
  List<DockingStation> get stationList => _stationList;

  Journey.map(DocumentSnapshot document, List<DockingStation> stationList) {
    _journeyDocumentId = document.id;
    _time = 
    _stationList = stationList;
  }
}
