import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../styles/animation/hero_dialog_route.dart';

Align buildWeatherIcon(context, weather, weatherIcon) {
  return Align(
    //EdgeInsets.only(left: 300, top: 150, right: 40, bottom: 550),
    alignment: Alignment(0.9, -0.75),
    child: SizedBox(
        height: MediaQuery.of(context).size.height / 15,
        width: MediaQuery.of(context).size.width / 7,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return _WeatherPopupCard(
                weather: weather,
              );
            }));
          },
          child: Hero(
            tag: "_heroWeather",
            child: Material(
              color: Colors.green[300],
              elevation: 2,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              //shape: CircleBorder(side: BorderSide(color: Colors.green)),
              child: Image.network(
                //late problem sort it
                'http://openweathermap.org/img/w/$weatherIcon.png',
              ),
            ),
          ),
        )),
  );
}

class _WeatherPopupCard extends StatelessWidget {
  const _WeatherPopupCard({Key? key, required this.weather}) : super(key: key);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "_heroWeather",
          child: Material(
            color: Colors.green[300],
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      //late problem sort it
                      'http://openweathermap.org/img/w/${weather.current_icon}.png',
                    ),
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
                        weather
                            .getCurrentWindSpeed()
                            .roundToDouble()
                            .toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
