import 'package:flutter/material.dart';
import 'colors.dart';
import 'styling.dart';

///Defines the possible themes of the apps
///Author(s): Marija, Tayyibah
class CustomTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      canvasColor: CustomColors.lightModeScaffoldColour,
      scaffoldBackgroundColor: CustomColors.lightModeScaffoldColour,
      appBarTheme: AppBarTheme(
        color: CustomColors.green,
        foregroundColor: CustomColors.appBarTextColor,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.red,
        contentTextStyle: TextStyle(fontSize: 17),
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titleTextStyle: popupDialogTitleTextStyle,
        contentTextStyle: popupDialogTextStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: CustomColors.green,
            onPrimary: Colors.white,
            padding: const EdgeInsets.all(12.0),
            textStyle:
                const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(color: Color(0xFF99D2A9)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          side: const BorderSide(color: Color(0x4D99D2A9), width: 1.0),
        ),
      ),
      listTileTheme: ListTileThemeData(textColor: CustomColors.green),
      primarySwatch: CustomColors.lightGreen,
      backgroundColor: CustomColors.green,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      canvasColor: CustomColors.darkModeScaffoldColour,
      scaffoldBackgroundColor: CustomColors.darkModeScaffoldColour,
      appBarTheme: AppBarTheme(color: CustomColors.darkModeScaffoldColour),
      primarySwatch: Colors.grey,
      colorScheme: ColorScheme.dark(
        secondary: CustomColors.darkModeScaffoldColour,
      ),
      backgroundColor: CustomColors.darkModeScaffoldColour,
      textTheme: ThemeData.dark().textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.darkModeScaffoldColour,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
