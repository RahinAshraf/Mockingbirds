import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/screens/profile_screen.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/sidebar.dart';
import 'package:veloplan/utilities/dart_exts.dart';

/// Defines the bottom navigation bar, allows you to move between the map, profile and sidebar.
/// Authors:  Elisabeth, Rahin, Tayyibah
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1; // index of the screens
  late final groupManager _groupManager;
  final DatabaseManager _databaseManager = DatabaseManager();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  _NavBarState() {
    _groupManager = groupManager(_databaseManager);
  }

  var screens = [
    Placeholder(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    screens.add(Profile(_currentUser));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: currentIndex,
          children: screens, // keeps the screens alive
        ),
        drawer: SideBar(),
        key: scaffoldKey,
        floatingActionButton: _createBikeButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _createNavBar());
  }

  BottomNavigationBar _createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 33,
      currentIndex: currentIndex,
      onTap: _onTabTapped, // (index) => setState(() => currentIndex = index)
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

  Widget _createBikeButton() {
    return SizedBox(
      height: 80.0,
      width: 80.0,
      child: FloatingActionButton(
        heroTag: "bike_button",
        key: Key("bike"),
        onPressed: () async {
          var hasGroup = await _isInAGroup();
          if (hasGroup == false) {
            _onTabTapped(1);
            Popups popup = Popups();
            showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) =>
                    popup.buildPopupDialogNewJourney(context));
          } else {
            _onTabTapped(1);
            _getGroupInfo();
          }
        },
        child: Icon(
          Icons.directions_bike,
          color: Colors.green,
          size: 50,
        ),
        elevation: 8.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  /// Returns whether a user already has a group or not.
  Future<bool> _isInAGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    if (user.data() != null) {
      var hasGroup = user.data()!.keys.contains('group');
      return hasGroup;
    }
    return false;
  }

  /// Retrieves group info and redirects to summary of journey screen.
  _getGroupInfo() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    if (user.data() != null && user.data()!.keys.contains('group')) {
      var group = await _databaseManager.getByEquality(
          'group', 'code', user.data()!['group']);
      var _itinerary = await _groupManager.getItineraryFromGroup(group);
      context.push(SummaryJourneyScreen(_itinerary, false));
    }
  }
}
