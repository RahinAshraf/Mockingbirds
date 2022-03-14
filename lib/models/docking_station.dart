import 'package:cloud_firestore/cloud_firestore.dart';

class DockingStation {
  late String _id;
  late String _name;
  late int _nb_bikes;
  late int _nb_empty_docks;
  late bool _installed;
  late bool _locked;
  late int _nb_total_docks;
  late double _lon;
  late double _lat;
  String? documentId;

  DockingStation(
      this._id,
      this._name,
      this._installed,
      this._locked,
      this._nb_bikes,
      this._nb_empty_docks,
      this._nb_total_docks,
      this._lon,
      this._lat);

  String get id => _id;
  String get name => _name;
  bool get installed => _installed;
  bool get locked => _locked;
  int get nb_bikes => _nb_bikes;
  int get nb_empty_docks => _nb_empty_docks;
  int get nb_total_docks => _nb_total_docks;
  double get lon => _lon;
  double get lat => _lon;

  DockingStation.map(DocumentSnapshot document) {
    documentId = document.id;
    _id = document.get('station_id');
    _name = document.get('name');
    _nb_bikes = document.get('nb_bikes');
    _nb_empty_docks = document.get('nb_empty_docks');
  }
}
