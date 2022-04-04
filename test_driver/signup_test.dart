import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('sign up', () {
    FlutterDriver? driver;
    // AuthForm
    final signUpScreen = find.byValueKey("AuthScreen");
    final signUpButton = find.byValueKey("signUpButton");
    final signUpButtonConfirm = find.byValueKey("logIn");
    final profileImageField = find.byValueKey("profileImage");
    final firstNameField = find.byValueKey("firstName");
    final lastNameField = find.byValueKey("lastName");
    final emailField = find.byValueKey("email");
    final usernameField = find.byValueKey("username");
    final passwordField = find.byValueKey("password");
    final confirmPassField = find.byValueKey("passwordConfirmation");
    final dateBirthField = find.byValueKey("date");
    final snackbar = find.byType("SnackBar");
    final datePicker = find.byType("datePicker");

    /// connect flutter driver to the app before executing the runs
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    /// disconnect flutter driver from the app after executing the runs
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });
    test("test open the sign up screen", () async {
      await driver?.tap(signUpButton);
      await driver?.waitFor(find.byType("AuthScreen"));
      await driver?.waitFor(find.byType("AuthForm"));
      await driver?.waitUntilNoTransientCallbacks();
      assert(find.byType("AuthScreen") != null);
      assert(find.byType("AuthForm") != null);
      assert(profileImageField != null);
      assert(firstNameField != null);
      assert(lastNameField != null);
      assert(usernameField != null);
      assert(passwordField != null);
      assert(emailField != null);
      assert(confirmPassField != null);
      assert(dateBirthField != null);
      // assert(choosePicField != null);
      // assert(takePicField != null);
    });

    test("test correctly fill in sign up", () async {
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("test integration");
      await driver?.tap(passwordField);
      await driver?.enterText("Password1234");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password1234");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      // await driver?.tap(dateBirthField);
      // await driver?.waitFor(dateBirthField);
      // await driver?.tap(find.text('12'));
      // await driver?.tap(find.text('12'));
      // await driver?.tap(find.text('2000'));
      await driver?.getCenter(find.byType("AuthForm"));
    });

    test("test correct fill in but younger than 16", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("test integration");
      await driver?.tap(passwordField);
      await driver?.enterText("Password1234");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password1234");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      // await driver?.tap(dateBirthField);
      // await driver?.waitFor(dateBirthField);
      // await driver?.tap(find.text('12'));
      // await driver?.tap(find.text('12'));
      // await driver?.tap(find.text('2000'));
      // await driver?.getCenter(find.byType("AuthScreen"));
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);
      await driver?.tap(signUpButtonConfirm);
      assert(snackbar != null);
      find.bySemanticsLabel("This field can not be empty");
    });

    test("test correct fill in but pass fields not the same", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("test integration");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password1234");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);
      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("The passwords did not match");
      find.bySemanticsLabel("This field can not be empty");

      assert(snackbar != null);
      // await driver?.waitUntilNoTransientCallbacks();
    });
    test("test correct fill in but pass not 7 characters long", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("test integration");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Pass");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Pa");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Password must be at least 7 characters long.");

      assert(snackbar != null);
    });
    test("test correct fill in but username is less than 4 characters long",
        () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("tes");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password123");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Please enter at least 4 characters");

      assert(snackbar != null);
    });

    test("test correct fill in but last name is less than 2 characters long",
        () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("I");
      await driver?.tap(usernameField);
      await driver?.enterText("testing");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password123");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Please enter at least 2 characters");

      assert(snackbar != null);
    });
    test("test correct fill in but first name is less than 2 characters long",
        () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("T");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("testing");
      await driver?.tap(emailField);
      await driver?.enterText("test@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password123");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Please enter at least 2 characters");

      assert(snackbar != null);
    });
    test("test correct fill in but invalid email is filled in", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("testing");
      await driver?.tap(emailField);
      await driver?.enterText("test");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password123");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Please enter a valid email");

      assert(snackbar != null);
    });
    test("test correct fill in but email already in the database", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("testing");
      await driver?.tap(emailField);
      await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password123");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      find.bySemanticsLabel("This field can not be empty");
      // find.bySemanticsLabel("Please enter a valid email");

      // assert(snackbar != null);
    });
    test("test correct fill in but password without numbers", () async {
      await driver?.waitUntilNoTransientCallbacks();
      Future.delayed(Duration(seconds: 5));
      await driver?.tap(firstNameField);
      await driver?.enterText("Test");
      await driver?.tap(lastNameField);
      await driver?.enterText("Integration");
      await driver?.tap(usernameField);
      await driver?.enterText("testing");
      await driver?.tap(emailField);
      await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password");
      await driver?.tap(confirmPassField);
      await driver?.enterText("Password");
      await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

      await driver?.tap(signUpButtonConfirm);
      // find.bySemanticsLabel("This field can not be empty");
      find.bySemanticsLabel("Please enter a valid email");

      assert(snackbar == null);
    });

    // test("test correct fill datepicker", () async {
    //   await driver?.waitUntilNoTransientCallbacks();
    //   Future.delayed(Duration(seconds: 5));
    //   await driver?.tap(firstNameField);
    //   await driver?.enterText("Test");
    //   await driver?.tap(lastNameField);
    //   await driver?.enterText("Integration");
    //   await driver?.tap(usernameField);
    //   await driver?.enterText("testing");
    //   await driver?.tap(emailField);
    //   await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
    //   await driver?.tap(passwordField);
    //   await driver?.enterText("Password");
    //   await driver?.tap(confirmPassField);
    //   await driver?.enterText("Password");

    //   await driver?.tap(dateBirthField);
    //   await driver?.scroll(datePicker, 50, 500, Duration(seconds: 10));
    //   // await driver?.scrollUntilVisible(datePicker, find.text('12'));
    //   // await driver?.scrollUntilVisible(datePicker, find.text('12'));
    //   // await driver?.scrollUntilVisible(datePicker, find.text('2000'));
    //   // await driver?.tap(find.text('12'));
    //   // await driver?.tap(find.text('12'));
    //   // await driver?.tap(find.text('2000'));
    //   await driver?.getCenter(find.byType("AuthScreen"));

    //   await driver?.scrollUntilVisible(signUpScreen, signUpButtonConfirm);

    //   await driver?.tap(signUpButtonConfirm);
    //   // find.bySemanticsLabel("This field can not be empty");
    //   find.bySemanticsLabel("Please enter a valid email");

    //   assert(snackbar == null);
    // });

    test("test alredy signed up, go to log in", () async {
      await driver?.tap(signUpButton);
      assert(find.byType("AuthForm") != null);
      assert(signUpScreen != null);
    });
  });
}
