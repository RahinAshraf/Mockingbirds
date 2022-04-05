import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';

/// Shows weather conditions in sidebar.
/// Author: Nicole
/// Contributor: Hristina-Andreea Sararu
class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather weather = Weather.defaultvalue();
  String weatherIcon = "1";
  WeatherManager _weatherManager = WeatherManager();
  LatLng currentPosition = getLatLngFromSharedPrefs();

  @override
  void initState() {
    _weatherManager
        .importWeatherForecast(
            currentPosition.latitude, currentPosition.longitude)
        .then((value) {
      if (mounted)
        setState(() {
          this.weather = _weatherManager.all_weather_data;
          this.weatherIcon = _weatherManager.all_weather_data.current_icon;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteReplacement,
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('Weather'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          SizedBox(
              key: Key("weatherIcon"),
              child: Center(
                child: Image.network(
                  'http://openweathermap.org/img/w/${weather.current_icon}.png',
                  scale: 0.3,
                ),
              )),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              key: Key("weatnerInfo"),
              children: [
                SizedBox(height: 50),
                Text(
                  weather.current_description,
                  style: CustomTextStyles.weatherTextStyle,
                ),
                Text(
                  "Temperature: " +
                      weather.getCurrentWeatherTemp().toInt().toString() +
                      "°C",
                  style: CustomTextStyles.weatherTextStyle,
                ),
                Text(
                  "Feels like: " +
                      weather
                          .getCurrentFeelsLikeTemp()
                          .roundToDouble()
                          .toString() +
                      "°C",
                  style: CustomTextStyles.weatherTextStyle,
                ),
                const SizedBox(height: 30),
                Text(
                  "Clouds: " + weather.getCurrentClouds().toString(),
                  style: CustomTextStyles.weatherTextStyle,
                ),
                Text(
                  "Visibility: " + weather.getCurrentVisibility().toString(),
                  style: CustomTextStyles.weatherTextStyle,
                ),
                Text(
                  "Wind speed: " +
                      weather.getCurrentWindSpeed().roundToDouble().toString(),
                  style: CustomTextStyles.weatherTextStyle,
                ),
              ]),
        ],
      ),
    );
  }
}
