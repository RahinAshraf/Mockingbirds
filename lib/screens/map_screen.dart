import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../.env.dart';
import 'dart:developer';
import '../animation/custom_rect_tween.dart';
import '../animation/hero_dialog_route.dart';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  FlutterMap _buildMap() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.512067, -0.039765),
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
    );
  }

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
        //.then((value) => initialiseWeather(_weatherManager.all_weather_data));
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
    setState(() {
      for (var station in docks) {
        _markers.add(Marker(
            point: LatLng(station.lat, station.lon),
            builder: (_) {
              return _buildCustomMarker();
            }));
      }
    });
  }

  Container _buildCustomMarker() {
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
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _buildMap(),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _buildWeatherIcon(),
        )
      ],
    ));
  }

  Widget _buildWeatherIcon() {
    return Padding(
        padding: EdgeInsets.only(left: 300, top: 150, right: 40),
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
              color: Colors.green,
              elevation: 2,

              //shape: RoundedRectangleBorder(
              //  borderRadius: BorderRadius.circular(32)),
              shape: CircleBorder(side: BorderSide(color: Colors.green)),
              child: Image.network(
                //late problem sort it
                'http://openweathermap.org/img/w/$weatherIcon.png',
              ),
            ),
          ),
        ));
  }
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
            color: Colors.green,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'New todo',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: const Text('Add'),
                    ),
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
