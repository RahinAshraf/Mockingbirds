import 'package:flutter/material.dart';
import 'package:veloplan/screens/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import '../widget/navigation_drawer_widget.dart';

class Navbar extends StatelessWidget {
  //We need to override the Build method because StatelessWidget has a build method
  @override
  Widget build(BuildContext context) {
    //every build method has a BuildContext method passed into it
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[900]), home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1; //index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final screens = [
    Placeholder(), //need to replace this with something?
    MapPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: screens[currentIndex], //looses the progress
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
                color: Colors.green,
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
          .fixed, //looks past the backround colors specified
      backgroundColor: Colors.green[200],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[10],
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
