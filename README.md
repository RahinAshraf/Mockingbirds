# veloplan

# Team *Mockingbirds* Large Group project

## -- README Report -- ##

## What is veloplan?

Veloplan is an android mobile app that helps you to get the most out of Satanders bicycle hire system everyday, making planning and taking trips around London with friends and family simple and stress-free. The app allows groups or individuals to plan an itinerary, with several destinations, and arranges a route that considers the number of bikes and free spaces needed with reliable and accurate information. Everything you need is in one place - you will be navigated turn by turn to your destinations, and you can choose to be automatically redirected during a journey when docking stations lose availability. Journeys can also be planned ahead of time using our scheduling feature, and you can create and join group journeys so no one is missed. With the ability to favourite docking stations, view past journeys, access the number of trips taken and miles covered, you can keep track of all the best places and motivate yourself to keep cycling. 

The chosen development framework is Flutter and Firebase for authentication and database management. As developers are new to all frameworks, we chose to focus soley on android, so the app does not run on IOS devices.


## Design Decisions

- We chose to make a switch from using the Google Maps API to Mapbox, due to a conflict with Googles Terms of Services. (See sections 10.4.c.ii of https://developers.google.com/maps/terms-20180207). This was a major setback mid development and as a result, there were several limitations with mapbox packages that we had to deal with. For example, the Mapbox Navigation Package has open issues (https://github.com/eopeter/flutter_mapbox_navigation/issues/145):

    - Turn by turn navigation can only be used once in an app run
    - Could not do redirecting with flutter_mapbox_navigation. The package is new and very unstable, so it doesn't allow modifications without the application crashing.

- To compromise, we implemented an additional feature that uses polyline navigation which successfuly navigates and updates the users destinations during journeys.

- For simplicity, group journeys exist for a maximum of a day and users can partake in one at a time.
- Users must be within 20 meters of the position specified for the starting point to begin a journey.  
- We removed the regex validator from the Log In form as if the user changes their password through firebase with one that doesn't match all criterias, they wouldn't be able to log in. We cannot modify the Firebase password reset sample.

All decisions were discussed with and agreed upon by the client. 

## Possible known bugs

- When planning a journey and entering starting/destination points, the list in the summary page is very rarely presented in the wrong order. We suspect this is due to API calls, and we could not resolve it as was irreproducible during testing.

## Limitations

- Due to Firebase,  it can take a while for data used in the 'favourites' and 'my journeys' screens to load and the colour of favourited cards to change.
- When launching the application, it can take a while for the landing screen to load due to all of the API calls initially made. 

## Future developments:

These features could not be complete due to time constraints:

- Users will be able to select cards from the edit dock screen and launch journeys from favourited cards. At the moment, users can only sort the cards.
- Allow users to create group journeys for prescheduled trips. 
- The profile page will be extended to include groups and 'about' information, and allow following/unfollowing other users.
- The weather feature will be extended to alert users about poor weather while planning trips.
- Group journey information will be displayed on the 'my journeys' page. The information for this is already saved in the database. 

## References list:

- lib/screens/navigation/turn_by_turn_screen.dart: 
    * dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation
    * AB Satyaprakash, Feb 20, 2022, https://github.com/Imperial-lord/mapbox-flutter
 - lib/screens/sidebar_screens/suggested_journeys.dart:
    * https://londonblog.tfl.gov.uk/2019/11/05/santander-cycles-sightseeing/?intcmp=60245


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
