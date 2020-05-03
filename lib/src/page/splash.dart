import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
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
        body: {'token': Site.token}
      );
      var data = json.decode(response.body);      
      //log.i(data);
      //  {"nav":{"name":"\u0e2a\u0e23\u0e49\u0e32\u0e07\u0e40\u0e27\u0e47\u0e1a\u0e44\u0e0b\u0e15\u0e4c","txt":"#ffffff","bg":"#008ad5"},"menu":{"type":"bottom","txt":"#555555","focus":"#ff4400","bg":"#f5f5f5"},"tab":[{"icon":"home","name":"\u0e25\u0e48\u0e32\u0e2a\u0e38\u0e14","type":"last","cate":"","article":0,"order":"last"},{"icon":"education","name":"\u0e2b\u0e21\u0e27\u0e14\u0e17\u0e31\u0e49\u0e07\u0e2b\u0e21\u0e14","type":"cate","cate":"","article":0,"order":"last"}]}
      Site.getData(data);
      
      
    } finally {
      client.close();
    }
    //log.e('................');
    return new Timer(Duration(seconds: 1),() {
      if(Site.template['login'] != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      //log.w(Site.template['home']);
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyPage()));
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
