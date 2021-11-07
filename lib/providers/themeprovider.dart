import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/style.dart';

import '../routetransition.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: isOn ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isOn ? Brightness.light : Brightness.dark,
        statusBarColor: isOn ? Colors.black : Colors.white,
      ),
    );
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    // appBarTheme: AppBarTheme(
    //   backwardsCompatibility: false, // 1
    //   systemOverlayStyle: SystemUiOverlayStyle.light, // 2
    // ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),

    textTheme: TextTheme(bodyText1: Style.display1),
    backgroundColor: Colors.white,

    // buttonColor: Color(0xffc8ba68),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
  );

  static final lightTheme = ThemeData(
    // appBarTheme: AppBarTheme(
    //   backwardsCompatibility: false, // 1
    //   systemOverlayStyle: SystemUiOverlayStyle.light, // 2
    // ),
    scaffoldBackgroundColor: Style.kMain,

    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),

    textTheme: TextTheme(bodyText1: Style.display1),
    backgroundColor: Colors.white,

    // buttonColor: Color(0xffc8ba68),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
  );
}
