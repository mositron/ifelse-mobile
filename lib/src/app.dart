import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'site.dart';
import 'my.dart';
import 'page/splash.dart';
import 'page/demo.dart';

class App {
  static void run(String token) async {
    Site.token = token;


    runApp(GetMaterialApp(
      home: Site.token.length == 10 ? SplashPage() : DemoPage(),
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

