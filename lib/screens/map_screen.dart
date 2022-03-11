import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:latlong2/latlong.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/route_manager.dart';
import '../helpers/live_location_helper.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import '../helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import '../.env.dart';
import 'package:veloplan/providers/location_service.dart';
import '../screens/turn_by_turn_screen.dart';
import '../helpers/zoom_helper.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
import 'package:location/location.dart';

//import 'package:veloplan/widget/carousel/station_carousel.dart';
const double zoom = 16;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  RouteManager manager = RouteManager();
  late Future<List<DockingStation>> future_docks;
  bool isRouteDisplayed = false;
  Map<String, Object> _fills = {};
  late Map routeResponse;
  bool showMarkers = false; //for displaying markers with button
  late Symbol? _selectedSymbol; //may remove
  Set<Symbol> polylineSymbols = {};
  // var zoom = LatLng(51.51185004458236, -0.11580820118980878);
  String googleMapsApi = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';
  String accessToken =
      'pk.eyJ1IjoibW9ja2luZ2JpcmRzZWxpdGUiLCJhIjoiY2wwaTJ2em4wMDA0ZzNrcGtremZuM3czZyJ9.PDaTlZiPjDa7sGjF-aKnJQ';
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  List<LatLng> points = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310),
    LatLng(51.502254, -0.217760),
  ];
  late MapboxMapController? controller;
  late CameraPosition _cameraPosition;
  LatLng currentLatLng = const LatLng(51.51185004458236, -0.11580820118980878);
  String totalDistance = 'No route';
  LatLng latLng = getLatLngFromSharedPrefs();
  // late CameraPosition _initialCameraPosition;
  TextEditingController _searchController = TextEditingController();
  Timer? timer;
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();


  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    //sharedPreferences.apply();
    print("UPDATED");
    print(_newLocationData.latitude!);
    print(_newLocationData.longitude!);
  }

  @override
  void initState() {
    super.initState();
    print("HEY");
    print(latLng.latitude);
    print(latLng.longitude);
    _cameraPosition =  CameraPosition(target: latLng, zoom: 12);
    // _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
    getRouteResponse();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => updateCurrentLocation()); ///////////////////////////////
  }

  void getRouteResponse() async {
    routeResponse = await manager.getDirections(points[0], points[1]);
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
  }

  void placeDockMarkers(List<DockingStation> docks) {
    for (var station in docks) {
      controller!.addSymbol(
        SymbolOptions(
            geometry: LatLng(station.lat, station.lon),
            iconSize: 0.7,
            iconImage: "assets/icon/bicycle.png"),
      );
    }
  }

  Future<void> _onSymbolTapped(Symbol symbol) async {
    print("Symbol has been tapped");
    _selectedSymbol = symbol;
    Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
    // _DockPopupCard(latlng: await variable,);
    if (_selectedSymbol != null) {
      //Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
      // print("This is:   " + variable.toString());
      LatLng current = await variable;
      print(await variable);
      print("CURRENT: " + current.toString());
      displayDockCard(current);
    }
  }

  void displayDockCard(LatLng current) {
    //CHANGE THIS TO CREATE CARD
    print("Will call widget next");
    // return _DockPopupCard(latlng: current,);
  }

  // void _onSymbolTapped(Symbol symbol) async {
  //   //This does not work
  //   if (_selectedSymbol != null) {
  //     print("tapped symbol");
  //     Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
  //     print(await variable);
  //   }
  //   setState(() {
  //     _selectedSymbol = symbol;
  //   });
  // }
  void _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    fetchDockingStations();
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  MapboxMap buildMap() {
    return MapboxMap(
      accessToken: MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: _cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
    );
  }

//This is just for testing purposes to see the docking station carousel:
  var _dockingStationCarousel = dockingStationCarousel();

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "refcous on live location",
          onPressed: () {   ////////////////////////////////////////////////////////////////////////////////////////////////
            controller?.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(target: getLatLngFromSharedPrefs(), zoom: 12)));
          },
          child: const Icon(Icons.my_location),
        ),

        /*
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: buildMap()),

              //Container(child: _dockingStationCarousel.buildCarousel()),

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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {
            controller?.animateCamera(
                CameraUpdate.newCameraPosition(_cameraPosition));
          },
          child: const Icon(Icons.my_location),
        ),*/
        body: SafeArea(
            child: Stack(
      children: [
        Container(
            alignment: Alignment(0, 0),
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            child: MapboxMap(
              accessToken: accessToken,
              initialCameraPosition: _cameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              annotationOrder: [AnnotationType.symbol],
              // minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            )), //
        Container(
          alignment: Alignment(-0.5, -0.5),
          child: (showMarkers)
              ? FloatingActionButton(
                  heroTag: "Show markers",
                  child: Icon(Icons.wallet_giftcard, color: Colors.white),
                  onPressed: fetchDockingStations, //placeMarkers,
                )
              : Container(),
        ),
        Container(
          alignment: Alignment(-0.5, -0.7),
          child: FloatingActionButton(
            heroTag: "+",
            child: Icon(Icons.add, color: Colors.white),
            onPressed: zoomIn,
          ),
        ),
        Container(
          alignment: Alignment(-0.9, -0.7),
          child: FloatingActionButton(
            heroTag: "-",
            child: Icon(Icons.horizontal_rule, color: Colors.white),
            onPressed: zoomOut,
          ),
        ),
        Container(
          alignment: Alignment(-0.9, 0),
          child: FloatingActionButton(
            heroTag: "Show polylines",
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () async {
              if (!isRouteDisplayed) {
                displayJourneyAndRefocus(points);
                isRouteDisplayed = true;
              } else {
                null;
              }
            },
          ),
        ),
        Container(
          alignment: Alignment(-0.5, 0),
          child: FloatingActionButton(
            heroTag: "Remove Polylines",
            child: Icon(Icons.remove, color: Colors.white),
            onPressed: () async {
              if (isRouteDisplayed) {
                removeFills();
                removeTimeAndDuration();
                isRouteDisplayed = false;
              }
            },
          ),
        ),
        Container(
          alignment: Alignment(-0.9, -0.5),
          child: FloatingActionButton(
            heroTag: "TBT",
            child: Icon(Icons.start, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => TurnByTurn(points))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment(0, 0.9),
            child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(totalDistance, style: TextStyle(fontSize: 25.0)),
                )),
          ),
        ),
      ],
    )));
  }

  _onStyleLoadedCallback() async {
    setState(() => showMarkers = true);
    //print(showMarkers);
  }

  Future<void> setFills(dynamic routeResponse) async {
    _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "geometry": routeResponse,
        },
      ],
    };
  }

  void displayJourneyAndRefocus(List<LatLng> journey) {
    setJourney(journey);
    refocusCamera(journey);
    setPolylineMarkers(journey);
  }

  void refocusCamera(List<LatLng> journey) {
    LatLng center = getCentroid(journey);
    // LatLng furthestPoint = getFurthestPointFromCenter(journey, center);
    // var top = getTopBound(journey);
    // var bounds = LatLngBounds(northeast: furthestPoint, southwest: top);
    // var target = LatLng(
    //     (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
    //     (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    // print(target.toString());
    _cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: 15, //getZoom(getRadius(journey, center)),
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void addFills() async {
    await controller!.addSource(
        "fills", GeojsonSourceProperties(data: _fills)); //creates the line
    await controller!.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Color.fromARGB(255, 197, 23, 23).toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 5,
      ),
    );
    // await controller.addSymbolLayer(sourceId, layerId, properties)
  }

  void removeFills() async {
    await controller!.removeLayer("lines");
    await controller!.removeSource("fills");
    controller!.removeSymbols(polylineSymbols);
    // _fills.clear();
    // polylineSymbols.clear();
    //removePolylineMarkers();
  }

  void removeTimeAndDuration() {
    setState(() {
      totalDistance = "No route";
    });
  }

  void setJourney(List<LatLng> journey) async {
    List<dynamic> journeyPoints = [];
    if (journey.length > 1) {
      routeResponse = await manager.getDirections(points[0], points[1]);
      for (int i = 0; i < journey.length - 1; ++i) {
        var directions = await manager.getDirections(points[i], points[i + 1]);
        for (dynamic a in directions['geometry']['coordinates']) {
          journeyPoints.add(a);
        }
        routeResponse['geometry']
            .update("coordinates", (value) => journeyPoints);
      }
      setFills(routeResponse['geometry']);
      addFills();
      setDistanceAndTime();

      // print("manager distance: " + a.toString());
    }
  }

  void setDistanceAndTime() async {
    try {
      var duration = await manager.getDistance() as double; //meters
      var distance = await manager.getDuration() as double; //sec
      print(duration.truncate());
      setState(() {
        totalDistance = "distance: " +
            (distance / 1000).toString() +
            ", duration: " +
            (duration / 60).truncate().toString();
        print(totalDistance);
      });
    } catch (e) {
      totalDistance = "Route not avalible";
    }
  }

  void setPolylineMarkers(List<LatLng> journey) async {
    for (var stop in journey) {
      polylineSymbols.add(await controller!.addSymbol(
        SymbolOptions(
            geometry: stop,
            iconSize: 0.1,
            iconImage: "assets/icon/yellow_marker.png"),
      ));
    }
  }

  void zoomIn() {
    _cameraPosition = CameraPosition(
        target: _cameraPosition.target,
        zoom: _cameraPosition.zoom + 0.5,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void zoomOut() {
    _cameraPosition = CameraPosition(
        target: _cameraPosition.target,
        zoom: _cameraPosition.zoom - 0.5,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}

// TODO: Fix camera zoom
// TODO: get the time
// TODO: Update path when button pressed
// TODO: Add walking route  (DONE: Create walking route manager)
// TODO: Duration and distance

// TODO: Camera zoom

// TODO: Error box when no internet -> check when future is called
// TODO: Future to the map

// DONE: Turn by turn directions
// DONE: Zoom in and zoom out buttons
// DONE: stop auto navigation - simulateRoute: false in turb_by_turn_screen.dart
// DONE: show markers for list of points
// DONE: show all markers for docking stations
