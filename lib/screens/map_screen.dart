import 'package:flutter/material.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../.env.dart';
import 'dart:developer';
import '../animation/custom_rect_tween.dart';
import '../animation/hero_dialog_route.dart';
import 'package:veloplan/screens/location_service.dart';

const double zoom = 16;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  TextEditingController _searchController = TextEditingController();

  late Future<List<DockingStation>> future_docks;
  late Weather weather;
  String weatherIcon = "10n";
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    fetchDockingStations();
    fetchWeather();
  }

  void fetchWeather() {
    final WeatherManager _weatherManager = WeatherManager();
    _weatherManager
        .importWeatherForecast(latLng.latitude, latLng.longitude)
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
            point: LatLong.LatLng(station.lat, station.lon),
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
        body: SafeArea(
            child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: MapboxMap(
                accessToken: MAPBOX_ACCESS_TOKEN,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
              ),
            ),
            _buildWeatherIcon(),

            //PLACEHOLDER FAB
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaceSearchScreen(LocationService())));
                print(
                    "This btn is to the search location screen. There is a screen in the design that comes before the search location screen so it is accessible from here for now");
              },
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition));
          },
          child: const Icon(Icons.my_location),
        ));
  }

  SizedBox _buildWeatherIcon() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 9,
        width: MediaQuery.of(context).size.width / 9,
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

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              //shape: CircleBorder(side: BorderSide(color: Colors.green)),
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
