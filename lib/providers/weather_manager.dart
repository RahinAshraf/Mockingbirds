import "package:http/http.dart" as http;
import '../models/weather.dart';
import 'dart:convert';
import 'dart:developer';

class WeatherManager {
  Weather all_weather_data = Weather.defaultvalue();

  Future<void> importWeatherForecast(double lat, double lon) async {
    var data = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=&appid=1deadbe1ade3be3687e03a43894d48a5"));
    var jsonData = json.decode(data.body);
    try {
      Weather current_weather = Weather(
          jsonData["current"]["temp"],
          jsonData["current"]["feels_like"],
          jsonData["current"]["clouds"],
          jsonData["current"]["visibility"],
          jsonData["current"]["wind_speed"],
          jsonData["current"]["weather"][0]["description"],
          jsonData["current"]["weather"][0]["icon"]);

      all_weather_data = current_weather;

      // all_weather_data.printWeather();
    } on FormatException {}
  }

  double convertKelvinToCelsius(double kel) {
    return kel - 273.15;
  }
}
