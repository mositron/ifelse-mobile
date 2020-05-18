
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'site.dart';
import 'page/home.dart';
import 'page/splash.dart';
import 'page/demo.dart';

class App {
  static void run(String token) {
    Site.token = token;
    runApp(GetMaterialApp(
      home: SplashPage(),
      /*
      initialRoute: '/' + (token.length != 10 ? 'demo' : 'splash'),
      routes: {
        '/splash': (context) => SplashPage(),
        '/demo': (context) => DemoPage(),
        '/home': (context) => HomePage(),
      }
      */
    ));
  }
}

