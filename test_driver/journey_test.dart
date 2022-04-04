//! aborted due to inability to wait for pannel widget to fill in all the 
//! locations on time

// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';

// /// integration tests for a journey
// /// TODO: split up navar, sidebar and profile
// /// Author(s): Elisabeth Halvorsen k20077737
// Future<void> main() async {
//   FlutterDriver? driver;

//   final navBarPage = find.byType("NavBar");
//   final startTrip = find.byValueKey("bike");
//   final planJourney = find.bySemanticsLabel("Plan a journey");
//   final proceedTrip = find.byValueKey("proceedTrip");
//   final whenToCycle = find.byType("TripSchedulerPanelWidget");
//   final now = find.byValueKey("now");
//   final later = find.byValueKey("later");

//   final journeyPlanner = find.byType("JourneyPlanner");
//   final summaryOfJourney = find.byType("SummaryJourneyScreen");

//   final whereFrom = find.byValueKey("myLocation");

//   final map = find.byValueKey("map");

//   final start = find.byValueKey("start");

//   setUpAll(() async {
//     driver = await FlutterDriver.connect();
//   });

//   ///  disconnect flutter driver from the app after executing the runs
//   tearDownAll(() async {
//     if (driver != null) {
//       driver?.close();
//     }
//   });

//   group("test scheduled journey", () {
//     test("test plan a journey", () async {
//       await driver?.waitUntilNoTransientCallbacks();
//       await driver?.waitFor(navBarPage);
//       assert(navBarPage != null);
//       await driver?.tap(startTrip);
//       await driver?.waitFor(planJourney);
//       assert(proceedTrip != null);
//       await driver?.tap(planJourney);
//     });

//     test("test trip details", () async {
//       await driver?.waitUntilNoTransientCallbacks();
//       await driver?.waitFor(whenToCycle);

//       assert(now != null);
//       assert(later != null);
//       assert(map != null);

//       await driver?.tap(now);
//     });

//     test("test journey planner", () async {
//       await driver?.waitUntilNoTransientCallbacks();
//       await driver?.waitFor(journeyPlanner);
//       await driver?.waitFor(whereFrom);
//       assert(journeyPlanner != null);
//       assert(whereFrom != null);

//       Future.delayed(Duration(seconds: 5));

//       await driver?.tap(whereFrom);
//       await driver?.waitUntilNoTransientCallbacks();
//       Future.delayed(Duration(seconds: 3));

//       await driver?.scrollIntoView(map);
//       await driver?.scroll(map, 200, 200, Duration(seconds: 2));

//       await driver?.waitUntilNoTransientCallbacks();

//       // await driver?.tap(start);
//     });

//     // test("test got back to navbar", () async {
//     //   await driver?.waitUntilNoTransientCallbacks();
//     //   await driver?.waitFor(summaryOfJourney);
//     //   assert(summaryOfJourney != null);
//     // });
//   });
// }
