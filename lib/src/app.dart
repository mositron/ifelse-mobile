
import 'package:flutter/material.dart';
import 'site.dart';
import 'page/home.dart';
import 'page/splash.dart';
import 'page/login.dart';

class App {
  static void run(token) {
    Site.token = token;
    runApp(MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
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

