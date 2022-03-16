import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'screens/navigation/map_screen.dart';
import 'screens/profile_screen.dart';
import 'sidebar.dart';
import '../styles/styling.dart';
import '../widgets/popup_widget.dart';
import '../sidebar.dart';
import '../screens/profile_screen.dart';
import '../screens/trips_scheduler_screen.dart';

///Authors: Elisabeth, Rahin, Tayyibah
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
                  useRootNavigator: false,
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
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
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:veloplan/providers/location_service.dart';
// import 'package:veloplan/screens/place_search_screen.dart';
// import 'screens/navigation/map_screen.dart';
// import 'screens/profile_screen.dart';
// import 'sidebar.dart';
// import 'package:veloplan/screens/trips_scheduler_screen.dart';

// ///Authors: Elisabeth, Rahin, Tayyibah
// class Navbar extends StatelessWidget {
//   //We need to override the Build method because StatelessWidget has a build method
//   @override
//   Widget build(BuildContext context) {
//     //every build method has a BuildContext method passed into it
//     return MaterialApp(
//         theme: ThemeData(
//           scaffoldBackgroundColor: const Color(0xffffffff),
//           primarySwatch: const MaterialColor(
//             0xff99d2a9, // 0%
//             <int, Color>{
//               50: Color(0xffa3d7b2), //10%
//               100: Color(0xffaddbba), //20%
//               200: Color(0xffb8e0c3), //30%
//               300: Color(0xffc2e4cb), //40%
//               400: Color(0xffcce9d4), //50%
//               500: Color(0xffd6eddd), //60%
//               600: Color(0xffe0f2e5), //70%
//               700: Color(0xffebf6ee), //80%
//               800: Color(0xfff5fbf6), //90%
//               900: Color(0xffffffff), //100%
//             },
//           ),
//           buttonTheme: ButtonTheme.of(context).copyWith(
//             //textTheme: ButtonTextTheme.primary,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ),
//         home: MainPage());
//   }
// }

// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int currentIndex = 1; //index of the screens

//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

//   final _currentUser = FirebaseAuth.instance.currentUser!.uid;

//   var screens = [
//     Placeholder(), //need to replace this with something?
//     MapPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     screens.add(Profile(_currentUser));
//     return Scaffold(
//         // body: screens[currentIndex], //looses the progress
//         body: IndexedStack(
//           index: currentIndex,
//           children: screens, //keeps the screens alive
//         ),
//         drawer: NavigationDrawerWidget(),
//         key: scaffoldKey,
//         floatingActionButton: Container(
//             height: 80.0,
//             width: 80.0,
//             child: TextButton(
//               onPressed: () {
//                 onTabTapped(1);
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => TripScheduler()));
//                 print("Link journey_planner screen to this btn");
//               },
//               child: const Icon(
//                 Icons.directions_bike,
//                 color: Colors.green,
//                 size: 50,
//               ),
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(90.0),
//                 ),
//                 maximumSize: Size.fromRadius(33),
//               ),
//             )),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: createNavBar());
//   }

//   BottomNavigationBar createNavBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       //looks past the background colors specified
//       backgroundColor: Colors.green[200],
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.grey[10],
//       iconSize: 33,
//       //selectedFontSize: 16,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       currentIndex: currentIndex,
//       onTap: onTabTapped,
//       //(index) => setState(() => currentIndex = index),
//       items: retrieveNavItems(),
//     );
//   }

//   List<BottomNavigationBarItem> retrieveNavItems() {
//     return const [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.format_align_justify_sharp),
//         label: '',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.add_link_rounded),
//         label: '',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.person),
//         label: '',
//       ),
//     ];
//   }

//   void onTabTapped(int index) {
//     setState(() {
//       if (index == 0) {
//         scaffoldKey.currentState!.openDrawer();
//       } else {
//         currentIndex = index;
//       }
//     });
//   }
// }
