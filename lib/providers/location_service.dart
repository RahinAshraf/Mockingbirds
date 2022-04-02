import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:mapbox_gl/mapbox_gl.dart';
import '../.env.dart';

class LocationService {
  final String key = MAPBOX_ACCESS_TOKEN; //Mapbox api key

  final StreamController<List<Feature>?> _feature =
      StreamController.broadcast();
  Stream<List<Feature>?> get feature => _feature.stream;

  //Adds the retrieved json data to a list
  void getPlaceFeatures(String input) async {
    final String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?limit=10&proximity=-0.12542189962264239,51.50218910230291&bbox=-0.591614,51.265980,0.279053,51.707474&access_token=$key"; //geocoding Api url request for data based on the users input, only showing retrieving matching results that are in London
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    final listOfPlace = (PlaceModel.fromJson(Map.from(json)).featureList);
    listOfPlace?.removeWhere((element) => element.placeName == null);
    _feature.sink.add(listOfPlace);
  }

  //Given coordinates, it will return the name of the place of those coordinates
  Future<Map> reverseGeoCode(double lat, double lng) async {
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$MAPBOX_ACCESS_TOKEN";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    Map feature = json['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': LatLng(lat, lng),
    };
    return revGeocode;
  }

  void close() {
    _feature.close();
  }

  //gets the coords of a place
  Future<List> getPlaceCoordsInLondon(String input) async {
    if (input.isEmpty) {
      return [];
    }

    final String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?limit=1&proximity=-0.12542189962264239,51.50218910230291&bbox=-0.591614,51.265980,0.279053,51.707474&access_token=$key"; //geocoding Api url request for data based on the users input, only showing retrieving matching results that are in London
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    List placeCoords = json['features'][0]['geometry']['coordinates'];
    List placeCoordsReversed = placeCoords.reversed
        .toList(); //switch (lng,lat) from server, to (lat,lng) to keep consistent with app
    return placeCoordsReversed;
  }

  //gets the coords of a place
  Future<List> getPlaceCoords(String input) async {
    if (input.isEmpty) {
      return [];
    }

    final String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?limit=1&access_token=$key"; //geocoding Api url request for data based on the users input, only showing retrieving matching results that are in London
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    List placeCoords = json['features'][0]['geometry']['coordinates'];
    List placeCoordsReversed = placeCoords.reversed
        .toList(); //switch (lng,lat) from server, to (lat,lng) to keep consistent with app
    return placeCoordsReversed;
  }
}

//Stores the data to do with the places we are interested in
class PlaceModel {
  List<Feature>? featureList;

  PlaceModel.fromJson(Map<String, dynamic> json) {
    if (json['features'] != null) {
      featureList =
          List.from((json['features']).map((value) => Feature.fromJson(value)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['features'] = featureList;
    return json;
  }
}

//Stores information about locations retrieved from the server
class Feature {
  String? placeName;
  String? matchingPlaceName;
  Geometry? geometry;

  Feature.fromJson(Map<String, dynamic> json) {
    matchingPlaceName = json['matching_place_name'];
    placeName = json['place_name'];
    geometry = Geometry.fromJson(json['geometry']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['matching_place_name'] = matchingPlaceName;
    json['place_name'] = placeName;
    json['geometry'] = geometry;
    return json;
  }
}

//Stores the geometric coordinates of a location
class Geometry {
  List<double?> coordinates = [];

  Geometry.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      final reversedIterable = List.from(json['coordinates'])
          .map((e) => double.tryParse(e.toString()))
          .toList()
          .reversed;
      coordinates = reversedIterable.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['coordinates'] = coordinates;
    return json;
  }
}
