import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/screens/profile_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/sidebar.dart';
import 'package:veloplan/widgets/popup_widget.dart';

///Authors: Elisabeth, Rahin, Tayyibah
class Navbar extends StatelessWidget {
  //We need to override the Build method because StatelessWidget has a build method
  @override
  Widget build(BuildContext context) {
    //every build method has a BuildContext method passed into it
    return MaterialApp(home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1; //index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  var screens = [
    Placeholder(), //need to replace this with something?
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    screens.add(Profile(_currentUser));
    return Scaffold(
        // body: screens[currentIndex], //looses the progress
        body: IndexedStack(
          index: currentIndex,
          children: screens, //keeps the screens alive
        ),
        drawer: NavigationDrawerWidget(),
        key: scaffoldKey,
        floatingActionButton: SizedBox(
            height: 80.0,
            width: 80.0,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                onTabTapped(1);
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
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

  PopupWidget _buildPopupDialog(BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        text: "Plan a journey",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TripScheduler()));
        },
      ),
      PopupButtonWidget(text: "Join a journey", onPressed: () {}),
    ];
    return PopupWidget(
        title: "Choose how to proceed with your trip!",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }

  BottomNavigationBar createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.green[200],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[10],
      iconSize: 33,
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