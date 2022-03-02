import 'package:cloud_firestore/cloud_firestore.dart';

///Represents a station that has been favourited by the user
class FavouriteDockingStation {
  late String id;
  late String _stationId, name, nb_bikes, nb_empty_docks;

  CollectionReference favourites =
      FirebaseFirestore.instance.collection('favourites');

  FavouriteDockingStation(this.id, this._stationId, this.name, this.nb_bikes,
      this.nb_empty_docks) {}

  FavouriteDockingStation.map(DocumentSnapshot document) {
    this.id = document.id;
    this._stationId = document.get('station_id');
    this.name = document.get('name');
    this.nb_bikes = document.get('nb_bikes');
    this.nb_empty_docks = document.get('nb_empty_docks');
  }

  Map toMap() {
    Map map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['station_id'] = stationId;
    return map;
  }

  String get stationId => _stationId;
}
