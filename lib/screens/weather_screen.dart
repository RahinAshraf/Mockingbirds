import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/styles/styling.dart';
// import 'package:veloplan/widgets/weather_popup_card.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather weather = Weather.defaultvalue();
  String weatherIcon = "10n";
  WeatherManager _weatherManager = WeatherManager();
  // Timer? timer;
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
    // startWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteReplacement,
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
                // height: 150.0,
                // width: 150.0,
                child: Center(
              child: Image.network(
                //late problem sort it
                'http://openweathermap.org/img/w/${weather.current_icon}.png',
                scale: 0.3,
              ),
            )),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 50),
              Text(
                weather.current_description,
                style: weatherTextStyle,
              ),
              Text(
                "Temperature: " +
                    weather.getCurrentWeatherTemp().toInt().toString() +
                    "C",
                style: weatherTextStyle,
              ),
              Text(
                "Feels like: " +
                    weather
                        .getCurrentFeelsLikeTemp()
                        .roundToDouble()
                        .toString() +
                    "C",
                style: weatherTextStyle,
              ),
              const SizedBox(height: 30),
              Text(
                "Clouds: " + weather.getCurrentClouds().toString(),
                style: weatherTextStyle,
              ),
              Text(
                "Visibility: " + weather.getCurrentVisibility().toString(),
                style: weatherTextStyle,
              ),
              Text(
                "Wind speed: " +
                    weather.getCurrentWindSpeed().roundToDouble().toString(),
                style: weatherTextStyle,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
