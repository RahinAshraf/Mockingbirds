import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> main() async {
  FlutterDriver? driver;

  final profilePageButton = find.byValueKey("profile");
  final bikePageButton = find.byValueKey("bike");
  final sideBarPageButton = find.byValueKey("sideBar");

// got to profile screen
  // final usernameField = find.byValueKey("email");
  final profileImageField = find.byValueKey("profileImage");
  // final imageField = find.byValueKey("imageProfile");
  final editImageField = find.byValueKey("editImageIcon");
  // final editImageField = find.byValueKey("editImageIcon");
  final editProfileButton = find.byValueKey("editProfileButton");
  final nameField = find.byValueKey("profileName");
  final emailField = find.byValueKey("profileEmail");
  final kmStatsField = find.byValueKey("distanceStats");
  final journeysStartsField = find.byValueKey("journeyStats");

// go to edit profile screen
  final editFirstNameField = find.byValueKey("firstNameEditP");
  final editLastNameField = find.byValueKey("lastNameEditP");
  final usernameEditProfileField = find.byValueKey("usernameNameEditP");
  final appNameField = find.byValueKey("appBarNameEditProfile");
  final backEditProfileButton = find.byValueKey("confirmEditProfile");
  final confirmEditProfileIcon = find.byValueKey("confirmEditProfile");
  final editImageEditProfileField = find.byValueKey("editImageIcon");

  //after you press go back to profile
  final popupEditProfile = find.byValueKey("editImageIcon");
  // final popupYesField = find.byValueKey("editImageIcon");
  // final popupNoField = find.byValueKey("editImageIcon");

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

  group("test profile", () {
    test("test has all navbar buttons", () async {
      assert(profilePageButton != null);
      assert(bikePageButton != null);
      assert(sideBarPageButton != null);
    });
    test("test all navbar buttons when in profile", () async {
      await driver?.tap(profilePageButton);
      await driver?.waitFor(find.byType("Profile"));
      assert(profilePageButton != null);
      assert(bikePageButton != null);
      assert(sideBarPageButton != null);
    });
    test("test has all profile fields", () async {
      assert(profileImageField != null);
      assert(editImageField != null);
      assert(editProfileButton != null);
      assert(nameField != null);
      assert(emailField != null);
      assert(kmStatsField != null);
      assert(journeysStartsField != null);
    });
    test("test go to edit profile", () async {
      assert(editProfileButton != null);
      await driver?.tap(editProfileButton);
      await driver?.waitFor(find.byType("EditProfile"));
      assert(editFirstNameField != null);
      assert(editLastNameField != null);
      assert(usernameEditProfileField != null);
      assert(appNameField != null);
      assert(backEditProfileButton != null);
      assert(confirmEditProfileIcon != null);
      assert(editImageEditProfileField != null);
    });

    test("test edit profile", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(editFirstNameField);
      await driver?.enterText("Integration");
      find.bySemanticsLabel("Integration");
      await driver?.tap(editLastNameField);
      await driver?.enterText("Testing");
      find.bySemanticsLabel("Testing");
      await driver?.tap(usernameEditProfileField);
      await driver?.enterText("Testing is really fun!");
      find.bySemanticsLabel("Testing is Fun");
    });

    test("test save profile", () async {
      await driver?.tap(confirmEditProfileIcon);
      await driver?.waitFor(find.byType("Profile"));
      assert(profileImageField != null);
      assert(editImageField != null);
      assert(editProfileButton != null);
      assert(nameField != null);
      assert(emailField != null);
      assert(kmStatsField != null);
      assert(journeysStartsField != null);
    });
    test("test change back to normal", () async {
      await driver?.waitUntilNoTransientCallbacks();
      await driver?.tap(editProfileButton);
      await driver?.waitFor(find.byType("EditProfile"));
      await driver?.tap(editFirstNameField);
      await driver?.enterText("Elisabeth");
      find.bySemanticsLabel("Elisabeth");
      await driver?.tap(editLastNameField);
      await driver?.enterText("Koren");
      find.bySemanticsLabel("Koren");
      await driver?.tap(usernameEditProfileField);
      await driver?.enterText("ellllkoren");
      find.bySemanticsLabel("ellllkoren");
      await driver?.tap(confirmEditProfileIcon);
      await driver?.waitFor(find.byType("Profile"));
    });
  });
}
