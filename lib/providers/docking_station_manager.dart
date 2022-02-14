import 'dart:convert';
import "package:http/http.dart" as http;
import "dart:io";
import '../models/docking_station.dart';

class dockingStationManager{

  List<DockingStation> stations = [];



  Future<void> importStations() async {var data =
  await http.get(Uri.parse("https://api.tfl.gov.uk/BikePoint"));
  var jsonData = json.decode(data.body);
  stations.clear();
  for (var station in jsonData) {
    try {
      DockingStation newStation =
      DockingStation(
          station["id"],
          station["commonName"],
          station["additionalProperties"][1]["value"] == "true",
          station["additionalProperties"][2]["value"] == "true",
          int.parse(station["additionalProperties"][6]["value"]),
          int.parse(station["additionalProperties"][7]["value"]),
          int.parse(station["additionalProperties"][8]["value"]),
          station["lon"],
          station["lat"]
      );

      if(!newStation.locked){
        stations.add(newStation);
      }

    } on FormatException{
    }
  }
  }

  List<DockingStation> get_all_open_stations(){
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if(!station.locked){
        openStations.add(station);
      }
    }
    return openStations;
  }

  List<DockingStation> get_all_stations_with_number_of_bikes(int numberOfBikes){
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if(station.nb_bikes>=numberOfBikes){
        openStations.add(station);
      }
    }
    return openStations;
  }

  List<DockingStation> get_all_stations_with_number_empty_docks(int numberOfDocks){
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if(station.nb_empty_docks>=numberOfDocks){
        openStations.add(station);
      }
    }
    return openStations;
  }








}