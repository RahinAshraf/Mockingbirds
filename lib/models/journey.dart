import 'package:cloud_firestore/cloud_firestore.dart';
import 'docking_station.dart';

///Represents a journey which is made up of list of docking stations
///Author: Tayyibah

class Journey {
  String? _journeyDocumentId;
  late List<DockingStation>
      _stationList; //list of docking stations in a journey
  String? _date;
  Journey(this._journeyDocumentId, this._stationList, this._date);

  String? get date => _date;
  String? get journeyDocumentId => _journeyDocumentId;
  List<DockingStation> get stationList => _stationList;

  Journey.map(DocumentSnapshot document, List<DockingStation> stationList) {
    _journeyDocumentId = document.id;
    _date = document.get('date');
    _stationList = stationList;
  }
}
