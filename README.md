# veloplan

# Team *Mockingbirds* Large Group project

## -- README Report -- ##

## What is veloplan?

veloplan is a mobile app that helps you to get the most out of Satanders bicycle hire system everyday, making planning and taking trips around London with friends and family simple and stress-free. The app allows groups or individuals to plan an itinerary, with several destinations, and arranges a route that considers the number of bikes and free spaces needed with reliable and accurate information. Everything you need is in one place - you will be navigated turn by turn to your destinations, and can choose to be redirected during a journey when docking stations lose availability. Journeys can also be planned ahead of time, and you can create and join group journeys so no one is missed.

veloplan was 


## Who are we?

- *Rahin Ashraf - k20034059*
- *Marija Buivyte - k20082541*
- *Fariha Choudhury - k20059723*
- *Elisabeth Halvorsen - k20077737*
- *Nicole Lehchevska - k20041914*
- *Eduard Ragea - k20067643*
- *Hristina-Andreea Sararu - k20036771*
- *Lilianna Szabo - k20070238*
- *Tayyibah Uddin - k20059556*


## Key features





## Design Decisions 

We chose to make a switch from using the Google Maps API to Mapbox, due to a conflict with Googles Terms of Services. (See sections 10.4.c.ii of https://developers.google.com/maps/terms-20180207). This was a major setback mid development and as a result, there were several limitations with mapbox packages that we had to deal with.

1. The Mapbox Navigation Package has open issues (https://github.com/eopeter/flutter_mapbox_navigation/issues/145):
    - Turn by turn navigation can only be used once in an app run
    - Could not do redirecting with flutter_mapbox_navigation
 To compromise, we implemented an additional feature that uses polyline navigation which successfuly redirects the user during journeys.

2. Mapbox did not support clustering symbols
    - https://github.com/flutter-mapbox-gl/maps/pull/797

All decisions were discussed with and agreed upon by the client. 

## Known bugs

- When planning a journey and entering starting/destination points, on rare occassions, the list in the sumarry page is presented in an incorrect order. This has not be resolved as it could not be recreated during testing, and is likely due to API calls which we could not control.
- 

## Future developments:


1. AI feature for predicting availability in each docking station.
2. Notifications: have a toggle in the settings to turn it on/off.                                                       
    Note: If a docking station is full or the weather conditions are not good enough for a journey, the user should be alerted.
3. Incentivising short journeys: encourage users to make journeys longer than 30 minutes and plan a stop in the middle.          
• Have a toggle in the settings to turn it on/off;                                                                           
• Find the closest docking station to the journey;
• Warning if existing journey gets too close to the limit (5 - 10 minutes before);
• Add a timer to the navigation screen that changes the colour when close to 30 minutes;
• Recalculate the length based on the average speed to see it user makes it in
30 minutes.

4. Update profile: enable short descriptions for users and have toggle ‘follow’ or ‘unfollow’ for sharing information with other users.




## References:
- lib/screens/navigation/turn_by_turn_screen.dart: 
    * dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation
    * AB Satyaprakash, Feb 20, 2022, https://github.com/Imperial-lord/mapbox-flutter
- lib/main.dart:
    * https://www.kindacode.com/article/how-to-disable-landscape-mode-in-flutter/
