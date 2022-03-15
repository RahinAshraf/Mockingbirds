import 'package:cloud_firestore/cloud_firestore.dart';

class DockingStation {
  late String _stationId;
  late String _name;
  late int _numberOfBikes;
  late int _numberOfEmptyDocks;
  late int _numberOfAllDocks;
  late bool _isInstalled;
  late bool _isLocked;
  late double _lon;
  late double _lat;
  String? _documentId;

  DockingStation(
      this._stationId,
      this._name,
      this._isInstalled,
      this._isLocked,
      this._numberOfBikes,
      this._numberOfEmptyDocks,
      this._numberOfAllDocks,
      this._lon,
      this._lat);

  String get stationId => _stationId;
  String get name => _name;
  bool get isInstalled => _isInstalled;
  bool get isLocked => _isLocked;
  int get numberOfBikes => _numberOfBikes;
  int get numberOfEmptyDocks => _numberOfEmptyDocks;
  int get numberOfAllDocks => _numberOfAllDocks;
  double get lon => _lon;
  double get lat => _lat;
  String? get documentId => _documentId;

  DockingStation.map(DocumentSnapshot document) {
    _documentId = document.id;
    _stationId = document.get('stationId');
    _name = document.get('name');
    _numberOfBikes = document.get('numberOfBikes');
    _numberOfEmptyDocks = document.get('numberOfEmptyDocks');
  }
}
