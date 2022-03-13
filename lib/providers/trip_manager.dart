import 'dart:convert';
import 'dart:developer';
import '../models/docking_station.dart';
import '../models/path.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import "package:http/http.dart" as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class TripManager {
  final List<List<double?>> coordList;
  final List<DockingStation> docksTrip = [];
  late List<Path> trip;
  final String YOUR_MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoibW9ja2luZ2JpcmRzZWxpdGUiLCJhIjoiY2wwaTJ2em4wMDA0ZzNrcGtremZuM3czZyJ9.PDaTlZiPjDa7sGjF-aKnJQ'; //Mapbox api key

  //[[51.523851, -0.031914], [-0.0962, 51.3532], [-0.1398817, 51.4889993]]

  TripManager(this.coordList) {}
  void importTrip() {
    final List<String> coordString = [];

    for (var i = 0; i < coordList.length; i++) {
      coordString.add(coordList[i][1]!.toString() + "%2C");
      coordString.add(coordList[i][0]!.toString() + "%3B");
    }
    //var data = await http.get(Uri.parse(
    log("https://api.mapbox.com/directions/v5/mapbox/cycling/${coordString.join()}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=simplified&steps=true&access_token=$YOUR_MAPBOX_ACCESS_TOKEN");
    //var jsonData = json.decode(data.body);
  }

  void createTrips() {
    for (var i = 0; i < coordList.length - 1; i++) {
      trip.add(Path(LatLong.LatLng(coordList[i][0]!, coordList[i][1]!),
          LatLong.LatLng(coordList[i + 1][0]!, coordList[i + 1][1]!)));
    }
  }
}
