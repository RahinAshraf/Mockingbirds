import 'package:cloud_firestore/cloud_firestore.dart';

///Represents a station that has been favourited by the user
class FavouriteDockingStation {
  late String id, _station_id, _name, _nb_bikes, _nb_empty_docks;

  FavouriteDockingStation(this.id, this._station_id, this._name, this._nb_bikes,
      this._nb_empty_docks);

  FavouriteDockingStation.map(DocumentSnapshot document) {
    this.id = document.id;
    this._station_id = document.get('station_id');
    this._name = document.get('name');
    this._nb_bikes = document.get('nb_bikes');
    this._nb_empty_docks = document.get('nb_empty_docks');
  }

  String get station_id => _station_id;
  String get name => _name;
  String get nb_bikes => _nb_bikes;
  String get nb_empty_docks => _nb_empty_docks;
}
