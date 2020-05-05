import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:async';
import 'dart:convert';
import '../site.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashPage> {
  static final log = Logger();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {    
    var client = new http.Client();
    try {
      var response = await client.post(
        Site.api + 'load',
        headers: {'user-agent': 'ifelse.co-'+Site.version},
        body: {'token': Site.token, 'session': Site.session}
      );
      Site.getData(json.decode(response.body), context);
    } finally {
      client.close();
    }
    //log.e('................');
    return new Timer(Duration(seconds: 1),() {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF),Color(0xFFDDDDDD),]
        )
      ),    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/splash-logo.png'),
          SizedBox(
            height: 50.0,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ]
      )
    );
  }
}
