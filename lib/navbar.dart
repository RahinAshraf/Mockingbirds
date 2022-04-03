import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/screens/profile_screen.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/sidebar.dart';
import 'package:veloplan/utilities/dart_exts.dart';

import 'helpers/database_helpers/database_manager.dart';
import 'helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'models/docking_station.dart';
import 'models/itinerary.dart';

/// Defines the bottom navigation bar, allows you to move between the map, profile and sidebar
/// @author  Elisabeth, Rahin, Tayyibah
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1; // index of the screens
  final DatabaseManager _databaseManager = DatabaseManager();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInGroup = false;
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  final Popups popup = Popups();

  var screens = [
    Placeholder(),
    MapPage(),
  ];

  void initState() {
    _isInAGroup();
    super.initState();
  }

  void _isInAGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var hasGroup = user.data()!.keys.contains('group');
    setState(() {
      _isInGroup = hasGroup;
    });
  }

  _getGroupInfo() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var group = await _databaseManager.getByEquality(
        'group', 'code', user.data()!['group']);

    var _itinerary = await _getDataFromGroup(group);

    context.push(SummaryJourneyScreen(_itinerary, false));
  }

  Future<Itinerary> _getDataFromGroup(
      QuerySnapshot<Map<String, dynamic>> group) async {
    List<DockingStation> _docks = [];
    var geoList = [];
    var _myDestinations;
    var _numberOfCyclists;
    for (var element in group.docs) {
      var itinerary = await element.reference.collection('itinerary').get();
      var journeyIDs = itinerary.docs.map((e) => e.id).toList();
      for (var journeyID in journeyIDs) {
        var journey = await element.reference
            .collection('itinerary')
            .doc(journeyID)
            .get();
        _numberOfCyclists = journey.data()!['numberOfCyclists'];
        geoList = journey.data()!['points'];
        var stationCollection =
            await journey.reference.collection("dockingStations").get();
        var stationMap = stationCollection.docs;
        _docks = List.filled(stationMap.length,
            DockingStation("fill", "fill", true, false, -1, -1, -1, 10, 20),
            growable: false);
        for (var station in stationMap)
          ({
            _docks[station.data()['index']] = (DockingStation(
              station.data()['id'],
              station.data()['name'],
              true,
              false,
              -1,
              -1,
              -1,
              station.data()['location'].longitude,
              station.data()['location'].latitude,
            ))
          });
        var coordinateCollection =
            await journey.reference.collection("coordinates").get();
        var coordMap = coordinateCollection.docs;
        geoList = List.filled(coordMap.length, GeoPoint(10, 20));
        for (var value in coordMap) {
          geoList[value.data()['index']] = value.data()['coordinate'];
        }
      }
      List<List<double>> tempList = [];
      for (int i = 0; i < geoList.length; i++) {
        tempList.add([geoList[i].latitude, geoList[i].longitude]);
      }

      _myDestinations = convertListDoubleToLatLng(tempList)?.toList();
    }
    return Itinerary.navigation(_docks, _myDestinations, _numberOfCyclists);
  }

  @override
  Widget build(BuildContext context) {
    screens.add(Profile(_currentUser));
    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens, // keeps the screens alive
        ),
        drawer: SideBar(),
        key: scaffoldKey,
        floatingActionButton: SizedBox(
            height: 80.0,
            width: 80.0,
            child: FloatingActionButton(
              key: Key("bike"),
              heroTag: "btn2",
              onPressed: () {
                if (!_isInGroup) _onTabTapped(1);
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (BuildContext context) =>
                        popup.buildPopupDialogNewJourney(context));
                if (_isInGroup) {
                  //_onTabTapped(1);
                  _getGroupInfo();
                }
              },
              child: const Icon(
                Icons.directions_bike,
                color: Colors.green,
                size: 50,
              ),
              elevation: 8.0,
              backgroundColor: Colors.white,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _createNavBar());
  }

  BottomNavigationBar _createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 33,
      currentIndex: currentIndex,
      onTap: _onTabTapped, // (index) => setState(() => currentIndex = index),
      items: _retrieveNavItems(),
    );
  }

  List<BottomNavigationBarItem> _retrieveNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.format_align_justify_sharp,
          key: Key("sideBar"),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_link_rounded),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person, key: Key("profile")),
        label: '',
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      index == 0
          ? scaffoldKey.currentState!.openDrawer()
          : currentIndex = index;
    });
  }
}
