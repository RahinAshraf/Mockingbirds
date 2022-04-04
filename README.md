# veloplan

# Team *Mockingbirds* Large Group project

## -- README Report -- ##

## What is veloplan?

Veloplan is an android mobile app that helps you to get the most out of Satanders bicycle hire system everyday, making planning and taking trips around London with friends and family simple and stress-free. The app allows groups or individuals to plan an itinerary, with several destinations, and arranges a route that considers the number of bikes and free spaces needed with reliable and accurate information. Everything you need is in one place - you will be navigated turn by turn to your destinations, and you can choose to be redirected during a journey when docking stations lose availability. Journeys can also be planned ahead of time, and you can create and join group journeys so no one is missed.

The chosen development framework is Flutter and Firebase for authentication and database management.

## Design Decisions/limitations

We chose to make a switch from using the Google Maps API to Mapbox, due to a conflict with Googles Terms of Services. (See sections 10.4.c.ii of https://developers.google.com/maps/terms-20180207). This was a major setback mid development and as a result, there were several limitations with mapbox packages that we had to deal with: 

    1. The Mapbox Navigation Package has open issues (https://github.com/eopeter/flutter_mapbox_navigation/issues/145):
        - Turn by turn navigation can only be used once in an app run
        - Could not do redirecting with flutter_mapbox_navigation. The package is new and very unstable, so it doesn't allow modifications without the application crashing.
     To compromise, we implemented an additional feature that uses polyline navigation which successfuly navigates and updates the users destinations during journeys.

[- lili stuff: one gruop at a time and cant have gruops for prescheduled trips
At the moment, 
tolerance for starting journeys need to be within 20 metres.]

The app does not run on IOS devices, as developers were all new to flutter so we chose to focus soley on android. 

We removed the regex validator from the Log In form as if the user changes their password through firebase with one that doesn't match all criterias, they wouldn't be able to log in. We cannot modify the Firebase password reset sample.

All decisions were discussed with and agreed upon by the client. 

## Possible known bugs/concerns

- When planning a journey and entering starting/destination points, the list in the sumarry page is presented in an incorrect order.
- Due to Firebase,  it can take a while for data used in screens to load and the colour of favourited cards to change.
- When launching the application, it can take a while for the landing screen to load due to all of the API calls that need to be made initially. 

## Future developments:
These features could not be complete due to time constraints:

- Users will be able to select cards from the edit dock screen and launch journeys from favourited cards. At the moment, users can only sort the cards.
- The weather feature will be extended to alert users about poor weather while planning trips.
- The profile page will be extended to include groups and 'about' information, and allow following/unfollowing other users.


## References list:

- lib/screens/navigation/turn_by_turn_screen.dart: 
    * dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation
    * AB Satyaprakash, Feb 20, 2022, https://github.com/Imperial-lord/mapbox-flutter


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
