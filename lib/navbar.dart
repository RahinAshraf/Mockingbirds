import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sidebar.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/trips_scheduler_screen.dart';
import '../widgets/popup_widget.dart';

///Defines the navigation bar, allows you to move between the map screen, profile page and view the sidebar.
/// @author  Elisabeth, Rahin, Tayyibah

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1; //index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
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
        bottomNavigationBar: _createNavBar());
  }

  BottomNavigationBar _createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType
          .fixed, //looks past the background colors specified
      iconSize: 33,
      currentIndex: currentIndex,
      onTap: _onTabTapped, //(index) => setState(() => currentIndex = index),
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
}
