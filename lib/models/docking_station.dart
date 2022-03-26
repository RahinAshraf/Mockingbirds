import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

///Represents a docking station
///Author(s): Liliana, Nicole, Tayyibah

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

  set setStationId(String temp) {
    _stationId = temp;
  }

  set setName(String temp) {
    _name = temp;
  }

  set setNumberOfBikes(int temp) {
    _numberOfBikes = temp;
  }

  set setNumberOfEmptyDocks(int temp) {
    _numberOfEmptyDocks = temp;
  }

  set setNumberOfAllDocks(int temp) {
    _numberOfAllDocks = temp;
  }

  set setIsInstalled(bool temp) {
    _isInstalled = temp;
  }

  set setisLocked(bool temp) {
    _isLocked = temp;
  }

  set setLon(double temp) {
    _lon = temp;
  }

  set setLat(double temp) {
    _lat = temp;
  }

  set setDocumentId(String temp) {
    _documentId = temp;
  }

  void assign(DockingStation other) {
    this._stationId = other.stationId;
    this._name = other.name;
    this._numberOfBikes = other._numberOfBikes;
    this._numberOfEmptyDocks = other.numberOfEmptyDocks;
    this._numberOfAllDocks = other._numberOfAllDocks;
    this._isInstalled = other._isInstalled;
    this._isLocked = other.isLocked;
    this._lon = other.lon;
    this._lat = other.lat;
  }

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

  ///Creates an instance of a docking station including its document id when added to firebase
  DockingStation.map(DocumentSnapshot document) {
    _documentId = document.id;
    _stationId = document.get('stationId');
    _name = document.get('name');
    _numberOfBikes = document.get('numberOfBikes');
    _numberOfEmptyDocks = document.get('numberOfEmptyDocks');
  }

  LatLng getLatlng() {
    return new LatLng(this._lat, this._lon);
  }

  /// An empty constructor useful for initialisations
  DockingStation.empty()
      : _stationId = "empty",
        _name = "empty",
        _isInstalled = false,
        _isLocked = true,
        _numberOfBikes = 0,
        _numberOfEmptyDocks = 0,
        _numberOfAllDocks = 0,
        _lon = 0.0,
        _lat = 0.0;
}
