import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/screens/navigation/polyline_turn_by_turn.dart';
import 'package:veloplan/screens/profile_screen.dart';
import 'package:veloplan/sidebar.dart';

/// Defines the bottom navigation bar, allows you to move between the map, profile and sidebar
/// @author  Elisabeth, Rahin, Tayyibah
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1; // index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  final Popups popup = Popups();

  var screens = [
    Placeholder(),
    MapPage(),
  ];

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
              heroTag: "btn2",
              onPressed: () {
                _onTabTapped(1);
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (BuildContext context) =>
                        popup.buildPopupDialogNewJourney(context));
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
        icon: Icon(Icons.format_align_justify_sharp),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_link_rounded),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
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
