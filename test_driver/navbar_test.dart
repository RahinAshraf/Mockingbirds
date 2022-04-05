import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// integration tests for the navabr sidebar
/// Author(s): Nicole Lehchevaska, Elisabeth Halvorsen k20077737
Future<void> main() async {
  FlutterDriver? driver;

  final profilePageButton = find.byValueKey("profile");
  final bikePageButton = find.byValueKey("bike");
  final sideBarPageButton = find.byValueKey("sideBar");
  final navBarPage = find.byType("NavBar");
  final profileScreen = find.byType("Profile");

  final scheduleButton = find.byValueKey("Schedule");
  final myJourneyBytton = find.byValueKey("My Journeys");
  final suggestedJourneyButton = find.byValueKey("Suggested Trips");
  final weatherButton = find.byValueKey("Weather");
  final settingsButton = find.byValueKey('Settings');
  final favouritesButton = find.byValueKey("Favourites");
  final helpBotButton = find.byValueKey("Help");

  final backButton = find.byValueKey("back");

  final scheduleScreen = find.byType("ScheduleScreen");
  final myJourneysScreen = find.byType("MyJourneys");
  final favouriteScreen = find.byType("Favourite");

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

  Future<void> testSidebar() async {
    await driver?.waitUntilNoTransientCallbacks();
    assert(scheduleButton != null);
    assert(myJourneyBytton != null);
    assert(suggestedJourneyButton != null);
    assert(weatherButton != null);
    assert(settingsButton != null);
    assert(favouritesButton != null);
    assert(helpBotButton != null);
  }

  group('Test navbar', () {
    test("test has all buttons", () async {
      await driver?.waitUntilNoTransientCallbacks();
      assert(profilePageButton != null);
      assert(bikePageButton != null);
      assert(sideBarPageButton != null);
    });
  });

  group("test sidebar", () {
    test("test has all sidebar options appears", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(sideBarPageButton);
      await testSidebar();
    });
  });

  group('Test sidebar screens when info is empty', () {
    test("test empty schedule screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(scheduleButton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(scheduleScreen != null);
      assert(find.byValueKey("calendar") != null);
      assert(find.byValueKey("noJourneys") != null);
      assert(find.byValueKey("eventCard") == null);
      assert(find.byValueKey("eventCards") == null);
      //! No planned journeys for this day
      //! Should display on calendar date
      //! You can delete a trip
      //!should add a journey and go in afterwards?
      assert(backButton != null);
      await driver?.tap(backButton);
    });

    test("test empty my journey screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(myJourneyBytton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(myJourneysScreen != null);
      assert(find.byValueKey("noJourneys") != null);
      assert(find.byValueKey("allJourneys") == null);
      //! Chech that there is no journeys made
      //! check if there are journeys
      //!check if the carousel comes up
      //! can fav the card
      assert(backButton != null);
      await driver?.tap(backButton);
    });

    test("test empty favourites screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(favouritesButton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(favouriteScreen != null);

      assert(find.byValueKey("noFavourites") != null);
      assert(find.byValueKey("allFavourites") == null);
      assert(find.byValueKey("dockCard") == null);
//! test that there is nothing added
//! test that there is something added
      assert(backButton != null);
      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });
  });

  group("test non changable sidebar screens", () {
    final suggestedTripScreen = find.byType("SuggestedItinerary");
    final weatherScreen = find.byType("WeatherPage");
    final helpBotScreen = find.byType("HelpScreen");
    final settingsScreen = find.byType("SettingsScreen");

    test("test suggested trips screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(suggestedJourneyButton);
      await driver?.waitFor(suggestedTripScreen);
      assert(suggestedTripScreen != null);
      assert(find.byValueKey("timelineTile") != null);

      //! when you tap on cards you are taken to sumamry of journey

      assert(backButton != null);
      await driver?.tap(backButton);
    });

    test("test weather screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(weatherButton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(weatherScreen != null);
      assert(find.byValueKey("weatherIcon") != null);
      assert(find.byValueKey("weatherInfo") != null);
      assert(backButton != null);
      await driver?.tap(backButton);

      /// see if there is text
      /// see if there is an icon
    });

    test("test help bot screen", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(helpBotButton);
      await driver?.waitUntilNoTransientCallbacks();
      assert(helpBotScreen != null);
      // final messageBubbles = find.byValueKey("messageBubble");
      // final questionBubbles = find.byValueKey("questionBubble");
      // expect(messageBubbles, 1);
      // expect(questionBubbles, 3);
      // driver?.tap(questionBubbles);
      // await driver?.waitUntilNoTransientCallbacks();
      //! fix this one

      assert(backButton != null);
      await driver?.tap(backButton);
    });

    test("test settings", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(settingsButton);
      assert(settingsScreen != null);
      await driver?.waitUntilNoTransientCallbacks();
      final logout = find.byValueKey("logOut");
      assert(logout != null);
      assert(find.byValueKey("changePassword") != null);
      assert(find.byValueKey("deleteAccunt") != null);
      assert(backButton != null);
      await driver?.tap(logout);
    });
  });

  group('Test sidebar screens when info is not empty', () {
    final scheduleScreen = find.byType("ScheduleScreen");
    final myJourneysScreen = find.byType("MyJourneys");
    final favouriteScreen = find.byType("Favourite");

    final sidebar = find.byType("SideBar");

    test("login with account with info", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(find.byValueKey("email"));
      await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
      await driver?.tap(find.byValueKey("password"));
      await driver?.enterText("Password123");
      await driver?.tap(find.byValueKey('logIn'));
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.waitFor(find.byType("NavBar"));
      assert(navBarPage != null);
    });

    test("test has all sidebar options appears", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(sideBarPageButton);
      await testSidebar();
    });

    ///! Due to unpredictable wait of time of fetching the information the tests
    ///! becomes unstable and impossible to validate everytime

    // test("test nonempty scheduled journeys", () async {
    //   await driver?.waitUntilNoTransientCallbacks();
    //   Future.delayed(Duration(seconds: 30));
    //   await driver?.tap(scheduleButton);
    //   await driver?.waitUntilNoTransientCallbacks();
    //   assert(scheduleScreen != null);

    //   final events = find.byValueKey("eventCards");
    //   await driver?.waitFor(events);
    //   assert(find.byValueKey("calendar") != null);
    //   assert(find.byValueKey("noJourneys") == null);
    //   assert(find.byValueKey("eventCard") != null);
    //   assert(events != null);

    //   assert(backButton != null);
    //   await driver?.tap(backButton);
    // });

    // test("test nonempty my journeys", () async {
    //   await driver?.waitUntilNoTransientCallbacks();
    //   await driver?.tap(myJourneyBytton);

    //   final journeys = find.byValueKey("allJourneys");
    //   await driver?.waitFor(journeys);

    //   assert(myJourneysScreen != null);
    //   assert(find.byValueKey("noJourneys") == null);
    //   assert(find.byValueKey("allJourneys") != null);

    //   assert(backButton != null);
    //   await driver?.tap(backButton);
    // });

    // test("test nonempty favourites", () async {
    //   await driver?.waitUntilNoTransientCallbacks();
    //   await driver?.tap(favouritesButton);
    //   await driver?.waitUntilNoTransientCallbacks();
    //   assert(favouriteScreen != null);
    //   final favs = find.byValueKey("allFavourites");
    //   await driver?.waitFor(favs);

    //   assert(find.byValueKey("noFavourites") == null);
    //   assert(favs != null);
    //   assert(find.byValueKey("dockCard") != null);

    //   assert(backButton != null);
    //   await driver?.tap(backButton);
    // });

    //! login with account with info
    test("test and navigate to profile page", () async {
      await driver?.waitUntilNoTransientCallbacks();
      assert(sidebar != null);
      await driver?.scroll(sidebar, -500, 0, Duration(seconds: 2));
      await driver?.waitUntilNoTransientCallbacks();
      assert(navBarPage != null);
      // assert(profilePageButton != null);
      // await driver?.tap(profilePageButton);
      // await driver?.waitUntilNoTransientCallbacks();
      // assert(profileScreen != null);
      // assert(navBarPage == null);
    });
  });
  //! make another group with information inside of the different screens
}

//TODO: add scheduled joruneys
// TODO: add some history
