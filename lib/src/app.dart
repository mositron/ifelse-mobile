import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:async';
import 'dart:convert';
import 'const.dart';
import 'icon.dart';
import 'page.dart';
import 'tab.dart';

class App {
  static void run(token) {
    Site.token = token;
    runApp(MaterialApp(
      home: SplashScreen(),
    ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
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
      var logger = Logger();
      logger.d(Site.api + 'load');
      logger.d(response.body);

      var load = json.decode(response.body);
      
      //  {"nav":{"name":"\u0e2a\u0e23\u0e49\u0e32\u0e07\u0e40\u0e27\u0e47\u0e1a\u0e44\u0e0b\u0e15\u0e4c","txt":"#ffffff","bg":"#008ad5"},"menu":{"type":"bottom","txt":"#555555","focus":"#ff4400","bg":"#f5f5f5"},"tab":[{"icon":"home","name":"\u0e25\u0e48\u0e32\u0e2a\u0e38\u0e14","type":"last","cate":"","article":0,"order":"last"},{"icon":"education","name":"\u0e2b\u0e21\u0e27\u0e14\u0e17\u0e31\u0e49\u0e07\u0e2b\u0e21\u0e14","type":"cate","cate":"","article":0,"order":"last"}]}
      Site.getData(load);
      Site.pageType = <Widget>[];
      Site.pageTab = <Tab>[];

      List<dynamic> bd = load['tab'];
      bd.forEach((b){
        String name = b['name'];
        String icon = b['icon'];
        String type = b['type'];
        List<dynamic> cate = b['cate'];
        String order = b['order'];
        String article = b['article'];
        Site.pageType.add(PageLast(icon: icon, name:name, type:type, cate: cate, order:order, article:article));
        Site.pageTab.add(
          Tab(
            icon: icon.isEmpty ? null : Icon(SIcons.icofont[icon]),
            text: name.isEmpty ? 'sss' : name,
          ),
        );
      });
    } finally {
      client.close();
    }
    return new Timer(Duration(seconds: 1),() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyPage()));
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
