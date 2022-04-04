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
import 'helpers/database_helpers/group_manager.dart';

import 'helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'models/docking_station.dart';
import 'models/itinerary.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';

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
  late final groupManager _groupManager;
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;
  final Popups popup = Popups();
  _NavBarState(){
     _groupManager = groupManager(_databaseManager);
  }

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

    var _itinerary = await _groupManager.getItineraryFromGroup(group);

    context.push(SummaryJourneyScreen(_itinerary, false));
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
