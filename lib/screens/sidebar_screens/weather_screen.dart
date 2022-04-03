import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/styles/styling.dart';

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
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('Weather'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
                key: Key("weatherIcon"),
                child: Center(
                  child: Image.network(
                    //late problem sort it
                    'http://openweathermap.org/img/w/${weather.current_icon}.png',
                    scale: 0.3,
                  ),
                )),
            Column(
                key: Key("weatnerInfo"),

                /// TODO: MARIJA AND HRISTINA: Make this look prettier
                //present some text if the length of journey list is 0 (e.g. 'you havent scheduled any journeys yet')
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  Text(weather.current_description),
                  Text("current temp: " +
                      weather.getCurrentWeatherTemp().toInt().toString() +
                      "C"),
                  Text("current feels like temp: " +
                      weather
                          .getCurrentFeelsLikeTemp()
                          .roundToDouble()
                          .toString() +
                      "C"),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  Text("current clouds: " +
                      weather.getCurrentClouds().toString()),
                  Text("current visibility: " +
                      weather.getCurrentVisibility().toString()),
                  Text("current wind speed: " +
                      weather.getCurrentWindSpeed().roundToDouble().toString()),
                ]),
          ],
        ),
      ),
    );
  }
}
