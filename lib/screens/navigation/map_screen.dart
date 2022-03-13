import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:latlong2/latlong.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
// import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/route_manager.dart';
import '../../helpers/navigation_helpers/navigation_helpers.dart';
import '../../helpers/navigation_helpers/map_drawings.dart';
// import '../login_screen.dart';
// import '../../navbar.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import '../helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import '../../.env.dart';
import 'package:veloplan/providers/location_service.dart';
import 'turn_by_turn_screen.dart';
import '../../helpers/navigation_helpers/zoom_helper.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import 'package:veloplan/.env.dart';
import 'map.dart';

/// A Map screen focused on a user's live location
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,

//import 'package:veloplan/widget/carousel/station_carousel.dart';
const double zoom = 16;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  RouteManager manager = RouteManager();
  bool isRouteDisplayed = false;
  late Map routeResponse;
  bool showMarkers = false; //for displaying markers with button

  Map<String, Object> _fills = {};
  Set<Symbol> polylineSymbols = {};
  late Symbol? _selectedSymbol; //may remove

  // var zoom = LatLng(51.51185004458236, -0.11580820118980878);
  // String googleMapsApi = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';
  String accessToken = MAPBOX_ACCESS_TOKEN;
  List<LatLng> points = [
    // LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    // LatLng(51.506053, -0.130310),
    LatLng(51.502254, -0.217760),
  ];
  late MapboxMapController? controller;
  late CameraPosition _cameraPosition;
  LatLng currentLatLng = const LatLng(51.51185004458236, -0.11580820118980878);
  String totalDistance = 'No route';
  LatLng latLng = getLatLngFromSharedPrefs();

  late NavigationModel _model;
  late NavigationMap _navigationMap;
  late MapboxMap map;

  // late CameraPosition _initialCameraPosition;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(target: currentLatLng, zoom: 12);
    // _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
    getRouteResponse();
  }

  void getRouteResponse() async {
    routeResponse = await manager.getDirections(points[0], points[1]);
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager.importStations().then(
        (value) => placeDockMarkers(controller!, _stationManager.stations));
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
    //! CAN BE MOVED TO HELPER ONCE HRISTINA IS FINISHED WITH IT
    print("Will call widget next");
  }

  void _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    fetchDockingStations();
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void initMap() {
    _model.setMap(MapboxMap(
      accessToken: accessToken,
      initialCameraPosition: _cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
    ));
    // _navigationMap = NavigationMap(
    //     MapboxMap(
    //       accessToken: accessToken,
    //       initialCameraPosition: _cameraPosition,
    //       onMapCreated: _onMapCreated,
    //       myLocationEnabled: true,
    //       myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
    //       annotationOrder: const [AnnotationType.symbol],
    //     ),
    //     _model);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(body: ScopedModelDescendant<NavigationModel>(
        builder: (BuildContext context, Widget? child, NavigationModel model) {
      _model = model;
      initMap();
      //_navigationMap = NavigationMap(model.getMap(), model);
      return SafeArea(
          child: Stack(
        children: [
          Container(alignment: Alignment(0, 0), child: _model.getMap()),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlaceSearchScreen(LocationService())));
              print(
                  "This btn is to the search location screen. There is a screen in the design that comes before the search location screen so it is accessible from here for now");
            },
          ),
          Container(
            alignment: Alignment(-0.5, -0.7),
            child: FloatingActionButton(
              heroTag: "+",
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _cameraPosition = zoomIn(_cameraPosition, controller);
              },
            ),
          ),
          Container(
            alignment: Alignment(-0.9, -0.7),
            child: FloatingActionButton(
              heroTag: "-",
              child: Icon(Icons.horizontal_rule, color: Colors.white),
              onPressed: () {
                _cameraPosition = zoomOut(_cameraPosition, controller);
              },
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
                  removeFills(controller!, polylineSymbols, _fills);
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TurnByTurn(points))),
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
                    child:
                        Text(totalDistance, style: TextStyle(fontSize: 25.0)),
                  )),
            ),
          ),
          Container(
            alignment: Alignment(0.9, 0.90),
            child: FloatingActionButton(
              heroTag: "center_to_current_loaction",
              onPressed: () {
                controller?.animateCamera(
                    CameraUpdate.newCameraPosition(_cameraPosition));
              },
              child: const Icon(Icons.my_location),
            ),
          )
        ],
      ));
    }));
  }

  _onStyleLoadedCallback() async {
    setState(() => showMarkers = true);
    //print(showMarkers);
  }

  void displayJourneyAndRefocus(List<LatLng> journey) {
    setJourney(journey);
    refocusCamera(journey);
    setPolylineMarkers(controller!, journey, polylineSymbols);
  }

  void refocusCamera(List<LatLng> journey) {
    LatLng center = getCenter(journey);
    // print(center);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(journey);
    print("radius: " + calculateDistance(center, corners.item1).toString());
    double zoom = getZoom(calculateDistance(center, corners.item1));

    _cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
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
      _fills = await setFills(_fills, routeResponse['geometry']);
      addFills(controller!, _fills, _model);
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
            (distance / 1000).truncate().toString() +
            ", duration: " +
            (duration / 60).truncate().toString();
        print(totalDistance);
      });
    } catch (e) {
      totalDistance = "Route not avalible";
    }
  }
}

// TODO: Fix camera zoom
// TODO: get the time
// TODO: Update path when button pressed- DONE?
//      ^^cancelling and reshowing polyline works, going back to map screen after pressing polyline also works

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
// DONE: set drawing related stuff into another class
