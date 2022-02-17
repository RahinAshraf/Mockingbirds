import "package:http/http.dart" as http;
import '../models/weather.dart';
import 'dart:convert';
import 'dart:developer';

class WeatherManager {
  double lat = 51.4707884;
  double lon = -0.1263955;
  List<Weather> all_weather_data = [];

  Future<void> importWeatherForecast() async {
    var data = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=&appid=edc1b9c88e6614d17f879f55bf392a00"));
    var jsonData = json.decode(data.body);
    all_weather_data.clear();
    try {
      Weather current_weather = Weather(
          jsonData["current"]["temp"],
          jsonData["current"]["feels_like"],
          jsonData["current"]["clouds"],
          jsonData["current"]["visibility"],
          jsonData["current"]["wind_speed"],
          jsonData["current"]["weather"][0]["description"],
          jsonData["current"]["weather"][0]["icon"]);
      all_weather_data.add(current_weather);
    } on FormatException {}
  }

  List<Weather> getWeatherData() {
    return all_weather_data;
  }

  double getCurrentTemp() {
    return all_weather_data[0].current_temp;
  }

  double getCurrentFeelsLike() {
    return all_weather_data[0].current_feels_like;
  }
}
