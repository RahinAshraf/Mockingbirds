# veloplan

# Team *Mockingbirds* Large Group project

## Team members
- *Rahin Ashraf - k20034059*
- *Marija Buivyte - k20082541*
- *Fariha Choudhury - k20059723*
- *Elisabeth Halvorsen - k20077737*
- *Nicole Lehchevska - k20041914*
- *Eduard Ragea - k20067643*
- *Hristina-Andreea Sararu - k20036771*
- *Lilianna Szabo - k20070238*
- *Tayyibah Uddin - k20059556*



A Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## -- README Report -- ##

## References:
- lib/screens/navigation/turn_by_turn_screen.dart: 
    * dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation
    * AB Satyaprakash, Feb 20, 2022, https://github.com/Imperial-lord/mapbox-flutter


## Design Decisions 
- Mapbox Navigation Package has issues with turn by turn direction.
    - A turn by turn navigation can only be used once in an app run and cannot edit the state of the journey.
    - Could not do redirecting with flutter_mapbox_navigation as there is an open bug with the app (https://github.com/eopeter/flutter_mapbox_navigation/issues/145)
    - Resorted to using polyline navigation for redirecting


## Bugs 
- journey_planner_screen.dart and panel_widget.dart
    - Journey planning produces the list of chosen docking stations in an incorrect order on very rare occassions (bug could not be recreated during testing but presence is speculated)
    - Due to API calls 


## Drawbacks faced during development
- Google Maps API and Directions API for turn-by-turn directions was not possible without breaching Google Maps privacy policy. 
    - (See sections 10.4.c.ii of https://developers.google.com/maps/terms-20180207). 
    - (Sources: https://stackoverflow.com/questions/57572927/open-google-maps-app-and-display-turn-by-turn-navigation-inside-flutter-webview, https://stackoverflow.com/questions/24531391/is-it-possible-to-create-turn-by-turn-gps-navigation-app-on-android-ios-using-go)
    - Resorted to switching Map APIs to Mapbox midway through project
