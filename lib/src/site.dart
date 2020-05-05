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
  static double dpi = 1;
  static Map<String, dynamic> template = {};
  static List<Widget> pageType = <Widget>[];
  static List<Widget> pageTab = <Widget>[];

  static void getData(dynamic load, BuildContext buildContext) {
    dpi = MediaQuery.of(buildContext).devicePixelRatio;
    log.i(dpi);
    id = getInt(load['_id']);
    name = load['name'];
    domain = load['domain'];
    ['splash','login','home','articles','article','products','product','cart','jobs','job'].forEach((v) {
      template[v] = load['theme'][v];
    });
  }
} 
