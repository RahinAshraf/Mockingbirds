import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/favourite_screen.dart';
import 'screens/help_screen.dart';
import 'screens/journey_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/setting_screen.dart';

// void main() => runApp(MyApp());

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
  int currentIndex = 0;
  final screens = [
    Favourite(),
    Help(),
    Journey(),
    MapPage(),
    Profile(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: screens[currentIndex], //looses the progress
      body: IndexedStack(
        index: currentIndex,
        children: screens, //keeps the screens alive
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType
              .fixed, //looks past the backround colors specified
          backgroundColor: Colors.purple[200],
          selectedItemColor: Colors.grey[900],
          unselectedItemColor: Colors.grey[400],
          //iconSize: 20,
          //selectedFontSize: 16,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'favourite',
              //backgroundColor: Colors.blue),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'help',
              //backgroundColor: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'journey',
              //backgroundColor: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile',
              //backgroundColor: Colors.red),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings),
            //   label: 'settings',
            // ), //backgroundColor: Colors.green)
          ]),
    );
  }
}
