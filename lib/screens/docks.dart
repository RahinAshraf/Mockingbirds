import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

/*
Future<Dock> fetchDock() async {
  final response =
      await httpyy.get(Uri.parse('https://api.tfl.gov.uk/bikepoint'));
  log("ClassName: successfully initialized: $jsonDecode(response.body)");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Dock.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load marker');
  }
}
class Dock {
  final double lon;
  final double lat;
  //final String name;

  const Dock({
    required this.lon,
    required this.lat,
//    required this.name,
  });

  factory Dock.fromJson(Map<String, dynamic> json) {
    return Dock(
      lon: json['lon'],
      lat: json['lat'],
//      name: json['name'],
    );
  }
}*/
Future<List<Dock>> fetchDock() async {
  var response = await http.get(Uri.parse('https://api.tfl.gov.uk/bikepoint'));

  var json = jsonDecode(response.body);
  var jsonResult = json as List;
  //log("this is the result $json.toList()");
  log("i have done: $jsonResult.map((dock) => Dock.fromJson(dock)).toList()");

  return jsonResult.map((dock) => Dock.fromJson(dock)).toList();
}

class Dock {
  final double lon;
  final double lat;

  const Dock({
    required this.lon,
    required this.lat,
  });

  Dock.fromJson(Map<dynamic, dynamic> parsedJson)
      : lat = parsedJson['lat'],
        lon = parsedJson['lon'];
}
