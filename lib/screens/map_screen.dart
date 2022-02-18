import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../.env.dart';
import 'dart:developer';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  late Future<List<DockingStation>> future_docks;
  late Weather weather;
  String weatherIcon = "10n";
  Set<Marker> _markers = Set<Marker>();
  @override
  void initState() {
    super.initState();
    fetchDockingStations();
    fetchWeather();
  }

  void fetchWeather() {
    final WeatherManager _weatherManager = WeatherManager();
    _weatherManager
        .importWeatherForecast()
        .then((value) => initialiseWeather(_weatherManager.all_weather_data));
  }

  void initialiseWeather(Weather w) {
    weather = w;
    weatherIcon = w.current_icon;
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
  }

  void placeDockMarkers(List<DockingStation> docks) {
    int i = 0;
    setState(() {
      for (var station in docks) {
        _markers.add(Marker(
            point: LatLng(station.lat, station.lon),
            builder: (_) {
              return Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://www.iconpacks.net/icons/1/free-icon-bicycle-1054.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }));
      }
    });
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(51.51185004458236, -0.11580820118980878),
              zoom: 16.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mockingbirds/ckzh4k81i000n16lcev9vknm5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNremd3NW9weDM2ZmEybm45dzlhYzN0ZnUifQ.lSzpNOhK2CH9-PODR0ojLg",
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              MarkerLayerOptions(
                markers: _markers.toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 300, top: 150, right: 40),
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.red,
              shape: CircleBorder(),
            ),
            child: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              backgroundColor: Colors.green,
              child: Image.network(
                //late problem sort it
                'http://openweathermap.org/img/w/$weatherIcon.png',
              ),
            ),
          ),
        )
      ],
    ));
  }
}
