
import 'package:flutter/material.dart';
import 'site.dart';
import 'page/home.dart';
import 'page/splash.dart';
import 'page/login.dart';
import 'page/demo.dart';

class App {
  static void run(String token) {
    Site.token = token;
    runApp(MaterialApp(
      initialRoute: '/' + (token.length != 10 ? 'demo' : 'splash'),
      routes: {
        '/splash': (context) => SplashPage(),
        '/demo': (context) => DemoPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/articles': (context) => HomePage(),
        '/article': (context) => HomePage(),
        '/products': (context) => HomePage(),
        '/product': (context) => HomePage(),
        '/cart': (context) => HomePage(),
        '/jobs': (context) => HomePage(),
        '/job': (context) => HomePage(),
      }
    ));
  }
}

