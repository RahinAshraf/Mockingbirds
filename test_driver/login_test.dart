import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'envVars.dart';

Future<void> main() async {
  group('log in', () {
    FlutterDriver? driver;
    final emailField = find.byValueKey("email");
    final passwordField = find.byValueKey("password");
    final loginButton = find.byValueKey('logIn');
    final snackbar = find.byType("SnackBar");
    final navBarPage = find.byType("NavBar");
    final emailErrorMessage = find.byValueKey("email");
    final passwordErrorMessage = find.byValueKey("password");

    /// connect flutter driver to the app before executing the runs
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await setUpEnvVars();
    });

    /// disconnect flutter driver from the app after executing the runs
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });

    // test("test incorrect password but correct email", () async {
    //   await driver?.tap(emailField);
    //   await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
    //   await driver?.tap(passwordField);
    //   await driver?.enterText("Password1234");
    //   await driver?.tap(loginButton);
    //   await driver?.waitFor(snackbar);
    //   assert(snackbar != null);
    //   await driver?.waitUntilNoTransientCallbacks();
    //   assert(navBarPage == null);
    // });

    // test("test correct password but incorrect email", () async {
    //   await driver?.waitForAbsent(snackbar);
    //   await driver?.tap(emailField);
    //   await driver?.enterText("elisabeth.koren.halvor@gmail.com");
    //   await driver?.tap(passwordField);
    //   await driver?.enterText("Password123");
    //   await driver?.tap(loginButton);
    //   await driver?.waitFor(snackbar);
    //   assert(snackbar != null);
    //   await driver?.waitUntilNoTransientCallbacks();
    //   assert(navBarPage == null);
    // });

    // test("test no fields filled in", () async {
    //   await driver?.waitForAbsent(snackbar);
    //   await driver?.tap(emailField);
    //   await driver?.enterText("");
    //   await driver?.tap(passwordField);
    //   await driver?.enterText("");
    //   await driver?.tap(loginButton);
    //   assert(snackbar == null);
    //   assert(passwordErrorMessage != null);
    //   assert(emailErrorMessage != null);
    //   await driver?.waitUntilNoTransientCallbacks();
    //   assert(navBarPage == null);
    // });

    test("login succeeded", () async {
      await driver?.waitForAbsent(snackbar);
      await driver?.tap(emailField);
      await driver?.enterText("elisabeth1999@sf-nett.no");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(loginButton);
      assert(snackbar == null);
      await driver?.waitFor(find.byType("NavBar"));
      assert(navBarPage == null);
    });
  });
}
