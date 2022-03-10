import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sidebar.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/trips_scheduler_screen.dart';
import '../styles/styling.dart';
import '../widgets/popup_widget.dart';

class Navbar extends StatelessWidget {
  //We need to override the Build method because StatelessWidget has a build method
  @override
  Widget build(BuildContext context) {
    //every build method has a BuildContext method passed into it
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: appBarColor,
            foregroundColor: appBarTextColor,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green[200],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[10],
          ),
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            titleTextStyle: popupDialogTitleTextStyle,
            contentTextStyle: popupDialogTextStyle,
          ),
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
                _onTabTapped(1);
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
        bottomNavigationBar: _createNavBar());
  }

  BottomNavigationBar _createNavBar() {
    return BottomNavigationBar(
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
