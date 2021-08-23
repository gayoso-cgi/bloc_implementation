import 'package:bloc_implementation/src/helper/config/theme_data.dart';
import 'package:bloc_implementation/src/views/splash_screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'helper/constants/strings_constants.dart';
import 'helper/routes/routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppNameString,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.initScreen(),
      theme: lightTheme,
      home: SplashScreen(),
    );
  }
}
