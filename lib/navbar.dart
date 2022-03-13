import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:veloplan/screens/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'sidebar.dart';

///Defines the navigation bar, allows you to move between the map screen, profile page and view the sidebar.
/// @author  Elisabeth, Rahin, Tayyibah

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1; //index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  var screens = [
    Placeholder(), //is this bad practise?
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    screens.add(Profile(_currentUser));
    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens, //keeps the screens alive
        ),
        drawer: NavigationDrawerWidget(),
        key: scaffoldKey,
        floatingActionButton: Container(
            height: 80.0,
            width: 80.0,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                onTabTapped(1);
                print("Link journey_planner screen to this btn");
              },
              child: const Icon(
                Icons.directions_bike,
                // color: Colors.green,
                size: 50,
              ),
              elevation: 8.0,
              backgroundColor: Colors.white,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: createNavBar());
  }

  BottomNavigationBar createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType
          .fixed, //looks past the background colors specified

      iconSize: 33,
      //selectedFontSize: 16,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTabTapped, //(index) => setState(() => currentIndex = index),
      items: retrieveNavItems(),
    );
  }

  List<BottomNavigationBarItem> retrieveNavItems() {
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

  void onTabTapped(int index) {
    setState(() {
      if (index == 0) {
        scaffoldKey.currentState!.openDrawer();
      } else {
        currentIndex = index;
      }
    });
  }
}
