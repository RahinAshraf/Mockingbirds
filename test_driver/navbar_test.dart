import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> main() async {
  FlutterDriver? driver;

  final profilePageButton = find.byValueKey("profile");
  final bikePageButton = find.byValueKey("bike");
  final sideBarPageButton = find.byValueKey("sideBar");

  /// connect flutter driver to the app before executing the runs

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  ///  disconnect flutter driver from the app after executing the runs
  tearDownAll(() async {
    if (driver != null) {
      driver?.close();
    }
  });
  group('Test navbar', () {
    test("test has all buttons", () async {
      await driver?.waitUntilNoTransientCallbacks();
      assert(profilePageButton != null);
      assert(bikePageButton != null);
      assert(sideBarPageButton != null);
    });
  });

  group('Test sidebar and sidebar windows when info is empty', () {
    final backButton = find.byValueKey("back");

    final scheduleButton = find.byValueKey("Schedule");
    final myJourneyBytton = find.byValueKey("My Journeys");
    final suggestedJourneyButton = find.byValueKey("Suggested Trips");
    final weatherButton = find.byValueKey("Weather");
    final settingsButton = find.byValueKey('Settings');
    final favouritesButton = find.byValueKey("Favourites");
    final helpBotButton = find.byValueKey("Help");

    final scheduleScreen = find.byType("ScheduleScreen");
    final myJourneysScreen = find.byType("MyJourneys");
    final favouriteScreen = find.byType("Favourite");
    final suggestedTripScreen = find.byType("SuggestedItinerary");
    final weatherScreen = find.byType("WeatherPage");
    final helpBotScreen = find.byType("HelpScreen");
    final settingsScreen = find.byType("SettingsScreen");

    test("test has all sidebar options appears", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(sideBarPageButton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(scheduleButton != null);
      assert(myJourneyBytton != null);
      assert(suggestedJourneyButton != null);
      assert(weatherButton != null);
      assert(settingsButton != null);
      assert(favouritesButton != null);
      assert(helpBotButton != null);
    });

    test("test schedule", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(scheduleButton);
      //! No planned journeys for this day
      //! Should display on calendar date
      //! You can delete a trip
      //!should add a journey and go in afterwards?
      assert(scheduleScreen != null);
      await driver?.tap(backButton);
    });

    test("test my journey", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(myJourneyBytton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(myJourneysScreen != null);
      //! Chech that there is no journeys made
      //! check if there are journeys
      //!check if the carousel comes up
      //! can fav the card
      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });

    test("test favourites", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(favouritesButton);
      assert(favouriteScreen != null);
      await driver?.waitUntilNoTransientCallbacks();
//! test that there is nothing added
//! test that there is something added
      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });

    test("test suggested trips", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(suggestedJourneyButton);
      assert(suggestedTripScreen != null);
      await driver?.waitUntilNoTransientCallbacks();
      //!present three cards
      //! when you tap on cards you are taken to sumamry of journey

      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });

    test("test weather", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(weatherButton);
      assert(weatherScreen != null);

      ///! see if there is text
      ///! see if there is an icon

      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });

    test("test help bot", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(helpBotButton);
      assert(helpBotScreen != null);
      await driver?.waitUntilNoTransientCallbacks();
      //! click on some options and see that progress
      await driver?.tap(backButton);
    });

    test("test settings", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(settingsButton);
      assert(settingsScreen != null);
      await driver?.waitUntilNoTransientCallbacks();
      //! check if logout was possible
      await driver?.tap(backButton);
    });
    //! login with account with info
  });

  //! make another group with information inside of the different screens
}
