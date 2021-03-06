import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'screens/splash.dart';
import 'util/color.dart';

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    GlobalConfiguration().loadFromPath("asset/config/app_settings.json");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
          title: 'NWL Meditations App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: primaryColor, fontFamily: 'Raleway'),
          home: Splash()),
    );
  }
}
