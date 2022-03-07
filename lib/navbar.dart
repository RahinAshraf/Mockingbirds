import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'sidebar.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';

class Navbar extends StatelessWidget {
  //We need to override the Build method because StatelessWidget has a build method
  @override
  Widget build(BuildContext context) {
    //every build method has a BuildContext method passed into it
    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffffffff),
          primarySwatch: const MaterialColor(
            0xff99d2a9, // 0%
            <int, Color>{
              50: Color(0xffa3d7b2), //10%
              100: Color(0xffaddbba), //20%
              200: Color(0xffb8e0c3), //30%
              300: Color(0xffc2e4cb), //40%
              400: Color(0xffcce9d4), //50%
              500: Color(0xffd6eddd), //60%
              600: Color(0xffe0f2e5), //70%
              700: Color(0xffebf6ee), //80%
              800: Color(0xfff5fbf6), //90%
              900: Color(0xffffffff), //100%
            },
          ),
          buttonTheme: ButtonTheme.of(context).copyWith(
            //textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1; //index of the screens

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
        floatingActionButton: Container(
            height: 80.0,
            width: 80.0,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                onTabTapped(1);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => TripScheduler()));
                // print("Link journey_planner screen to this btn");
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
          .fixed, //looks past the background colors specified
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

  // MARIJA
  Widget _buildPopupDialog(BuildContext context) {
    return Stack(
      alignment: Alignment(0, -0.28),
      children: [
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
          titlePadding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
          title: Center(
            child: const Text(
              'Choose how to proceed with your trip!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Color(0xFF7C8691),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: const Text(
                  "Only one way to find out.",
                  style: TextStyle(
                    color: Color(0xffD3DAE0),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: const BoxDecoration(
                  color: Color(0XFFF1F5F8),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade200),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0XFFFBAB4B)),
                      ),
                      onPressed: () {
                        // TODO: redirect to group ID
                      },
                      child: const Text(
                        "Join journey",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade200),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0XFFFBAB4B)),
                      ),
                      onPressed: () {
                        // TODO: redirect to new journey planner
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripScheduler()));
                      },
                      child: const Text(
                        "Plan journey",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Image(
            image: NetworkImage(
                "https://icons.iconarchive.com/icons/custom-icon-design/flatastic-1/72/alert-icon.png")),
      ],
    );
  }
}
