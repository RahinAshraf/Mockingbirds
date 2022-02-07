import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

//REFACTOR THIS CODE LATER TO USE DEFENSE PROGRAMMING - EG: TRY/CATCH

class LocationService {
  final String key = "AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU";

  Future<String> getPlaceId(String input) async {
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    print(results);
    return results;
  }

  void findPlace(String placeName) async {
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$key";
      var response =  await http.get(Uri.parse(autoCompleteUrl));

      print("PLACES PREDICTION RESPONSE:");
      print(response.body);

    }
  }

}

class RequestAssistance{

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

