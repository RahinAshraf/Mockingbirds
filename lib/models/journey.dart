import 'package:cloud_firestore/cloud_firestore.dart';
import 'docking_station.dart';

///Represents a journey
///Author: Tayyibah

class Journey {
  String? _journeyDocumentId;
  late List<DockingStation>
      _stationList; //list of docking stations in a journey

  Journey(this._journeyDocumentId, this._stationList);

  String? get journeyDocumentId => _journeyDocumentId;
  List<DockingStation> get stationList => _stationList;

  // Journey.map(DocumentSnapshot document) {
  //   _documentId = document.id;
  //   _stationId = document.get('stationId');
  //   _name = document.get('name');
  //   _numberOfBikes = document.get('numberOfBikes');
  //   _numberOfEmptyDocks = document.get('numberOfEmptyDocks');
  // }

}
