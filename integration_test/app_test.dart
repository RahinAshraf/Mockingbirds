import 'package:flutter/widgets.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
  group("Flutter auth tests",()
  {
    final emailField = find.byValueKey("email");
    final passwordField = find.byValueKey("password");
    final loginButton = find.byValueKey('logIn');
    final snackbar = find.byType("SnackBar");
    final navBarPage = find.byType("NavBar");

    FlutterDriver? driver;
//
//
    setUpAll(() async {
      /// ACCESS_COARSE_LOCATION
      // ACCESS_BACKGROUND_LOCATION
      // ACCESS_FINE_LOCATION
      driver = await FlutterDriver.connect();
//        final Map<String, String> envVars = Platform.environment;
//        final String adbPath = envVars['ANDROID_SDK_ROOT']! + '/platform-tools/adb.exe';
//         await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.READ_EXTERNAL_STORAGE']);
//         await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.READ_PHONE_STATE']);
//       await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.ACCESS_FINE_LOCATION']);
//         driver = await FlutterDriver.connect();
//       driver = await FlutterDriver.connect(timeout: Duration(seconds: 5));
//       await Process.run('add_adb_path/adb.exe' , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.ACCESS_MEDIA_LOCATION']);
//       await Process.run('add_adb_path/adb.exe' , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.ACCESS_COARSE_LOCATION']);
//       await Process.run('add_adb_path/adb.exe' , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.ACCESS_BACKGROUND_LOCATION']);
      // await Process.run('add_adb_path/adb.exe' , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.READ_EXTERNAL_STORAGE']);
      // await Process.run('add_adb_path/adb.exe' , ['shell' ,'pm', 'grant', 'com.example.veloplan', 'android.permission.WRITE_EXTERNAL_STORAGE']);


      // var connected = false;
      //   while (!connected) {
      //     try {
      //       await driver?.waitUntilFirstFrameRasterized();
      //       connected = true;
      //     } catch (error) {}
      //   }
    });

    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });


    test("login failed", () async {
      await driver?.tap(emailField);
      await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
//       await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password1234");
      await driver?.tap(loginButton);
      await driver?.waitFor(snackbar);
      assert(snackbar!=null);
//       assert(snackbar == null);
      await driver?.waitUntilNoTransientCallbacks();
      assert(navBarPage == null);
    });
//
//
//   });

    // Future<FlutterDriver> setupAndGetDriver() async {
    //   FlutterDriver driver = await FlutterDriver.connect();
    //   var connected = false;
    //   while (!connected) {
    //     try {
    //       await driver.waitUntilFirstFrameRasterized();
    //       connected = true;
    //     } catch (error) {}
    //   }
    //   return driver;
    // }


//   ! before
//   final email = find.byKey(Key('email'));
//   final password = find.byKey(Key('password'));
//   final loginButton = find.byKey(Key('logIn'));
//   // final acceptLocation = find.byType();
//
//   testWidgets("test unsuccessful log in", (tester) async {
//     app.main();
//     await tester.pumpAndSettle(); // done updating stuff
//     // final loginButton = find.byType(type)
//     await tester.enterText(email, "elisabeth.koren.halvorsen@gmail");
//     await tester.pumpAndSettle();
//
//     await tester.enterText(password, "Password123");
//     await tester.pumpAndSettle();
//
//     await tester.tap(loginButton);
//     await tester.pumpAndSettle();
//
//     final errorMessage = find.byKey(Key("Firebase Auth Error"));
//     print("error message ------------------------------");
//     print(errorMessage.toString());
//     expect(errorMessage, "");
//   });
//
//   testWidgets("successfull log in", (tester) async {
//     app.main();
//     await tester.pumpAndSettle(); // done updating stuff
//     // final loginButton = find.byType(type)
//     await tester.enterText(email, "elisabeth.koren.halvorsen@gmail.com");
//     await tester.pumpAndSettle();
//
//     await tester.enterText(password, "Password123");
//     await tester.pumpAndSettle();
//
//     await tester.tap(loginButton);
//     await tester.pumpAndSettle();
//   });


  });
}

  // group("veloplan", () {
  //   FlutterDriver driver;

  //   setUpAll(() async {
  //     driver = await FlutterDriver.connect();
  //   });

  //   tearDownAll(() {
  //     if (driver != null) {
  //       driver.close();
  //     }
  //   });
  // });

  // group('end-to-end test', () {
  //   testWidgets('tap on the floating action button, verify counter',
  //       (WidgetTester tester) async {
  //     app.main();
  //     await tester.pumpAndSettle();

  //     // Verify the counter starts at 0.
  //     expect(find.text('0'), findsOneWidget);

  //     // Finds the floating action button to tap on.
  //     final Finder fab = find.byTooltip('Increment');

  //     // Emulate a tap on the floating action button.
  //     await tester.tap(fab);

  //     // Trigger a frame.
  //     await tester.pumpAndSettle();

  //     // Verify the counter increments by 1.
  //     expect(find.text('1'), findsOneWidget);
  //   });
  // });
