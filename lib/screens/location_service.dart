import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*
*LocationService class retrieves the data from the google cloud maps api
* */
class LocationService {
  final String key = 'pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNremd3NW9weDM2ZmEybm45dzlhYzN0ZnUifQ.lSzpNOhK2CH9-PODR0ojLg'; //google cloud API KEY

  final StreamController<List<Feature>?> _feature = StreamController.broadcast();
  Stream<List<Feature>?> get feature => _feature.stream;

  //returns the id of the place the user inputs
  void getPlaceFeatures(String input) async {
    //final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    final String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?access_token=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    final listOfPlace = (PlaceModel.fromJson(Map.from(json)).featureList);

    listOfPlace?.removeWhere((element) => element.placeName == null);
    _feature.sink.add(listOfPlace);
  }

  void close(){
    _feature.close();
  }
}

class PlaceModel {

  List<Feature>? featureList;

  PlaceModel.fromJson(Map<String, dynamic> json){
    if(json['features'] != null){
      featureList = List.from((json['features']).map((value) =>Feature.fromJson(value)));
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = {};
    json['features'] = featureList;
    return json;
  }

}

class Feature {
  String? placeName;
  String? matchingPlaceName;

  Feature.fromJson(Map<String, dynamic> json){
    matchingPlaceName = json['matching_place_name'];
    placeName = json['place_name'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = {};
    json['matching_place_name'] = matchingPlaceName;
    json['place_name'] = placeName;
    return json;
  }
}


/*
* Given a url, it performs requests for us.
*/
class RequestAssistance{

  //If request valid, returns the object that was requested
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try{
      if(response.statusCode == 200){
        String jsonData = response.body;
        var decodeData = convert.jsonDecode(jsonData);
        return decodeData;
      }
      else{
        return "Failed, No response!";
      }
    }
    catch(exp){ return "Failed"; }
  }

}

