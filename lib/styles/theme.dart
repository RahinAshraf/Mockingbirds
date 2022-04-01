import 'package:flutter/material.dart';
import 'package:veloplan/styles/texts.dart';
import 'colors.dart';

/// Defines the possible themes of the apps
/// Author(s): Marija, Tayyibah
class CustomTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      canvasColor: CustomColors.lightModeScaffoldColour,
      scaffoldBackgroundColor: CustomColors.lightModeScaffoldColour,
      primarySwatch: CustomColors.lightGreen,
      backgroundColor: CustomColors.green,
      appBarTheme: AppBarTheme(
        color: CustomColors.green,
        foregroundColor: CustomColors.appBarTextColor,
      ),
      textTheme: TextTheme(
        headline1: CustomTextStyles.headline1,
        headline2: CustomTextStyles.headline2,
        headline5: CustomTextStyles.headline5,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.red,
        contentTextStyle: TextStyle(fontSize: 17),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titleTextStyle: CustomTextStyles.popupDialogTitleTextStyle,
        contentTextStyle: CustomTextStyles.popupDialogTextStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: CustomColors.green,
            onPrimary: Colors.white,
            padding: const EdgeInsets.all(12.0),
            textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      ),
      dividerColor: Color(0x4D99D2A9),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(color: Color(0xFF99D2A9)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          side: const BorderSide(color: Color(0x4D99D2A9), width: 1.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: CustomColors.green,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }
}
