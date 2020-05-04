import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'convert/util.dart';

class Site {
  static String api = 'https://api.ifelse.co/mobile/v1/';
  static String version = '0.1.0';

  static final log = Logger();
  static int id = 0;
  static String name = '';
  static String domain = '';
  static String token = '';
  static String session = '';
  static Map<String, dynamic> template = {};
  static List<Widget> pageType = <Widget>[];
  static List<Widget> pageTab = <Widget>[];

  static void getData(dynamic load) {
    Site.id = getInt(load['_id']);
    Site.name = load['name'];
    Site.domain = load['domain'];
    ['splash','login','home','articles','article','products','product','cart','jobs','job'].forEach((v) {
      Site.template[v] = load['theme'][v];
    });
  }
} 
