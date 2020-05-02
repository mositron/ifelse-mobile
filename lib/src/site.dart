import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'convert/int.dart';

class Site {
  static String api = 'https://api.ifelse.co/mobile/v1/';
  static String token = '';
  static String version = '0.1.0';

  static final log = Logger();
  static int id = 0;
  static String name = '';
  static String domain = '';

  static Map<String, dynamic> template = {
    'splash' : null,
    'login' : null,
    'home' : null,
    'splash' : null,
    'articles': {null,null,null},
    'article': {null,null,null},
    'products': {null,null,null},
    'product': {null,null,null},
    'cart' : null,
    'jobs' : null,
    'job' : null,
  };

  //static List<BottomNavigationBarItem> pageBar = <BottomNavigationBarItem>[];
  //static List<Map<String,String>> pageBody = <Map<String,String>>[];
  static List<Widget> pageType = <Widget>[];
  static List<Widget> pageTab = <Widget>[];

  static void getData(dynamic load) {
    Site.id = getInt(load['_id']);
    Site.name = load['name'];
    Site.domain = load['domain'];
    //log.e(load['theme']);
    load['theme'].forEach((k,v) {
      if(Site.template[k] == null) {
        Site.template[k] = v;
        //log.w(k, Site.template[k]);
      }      
    });
  }
}
