import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'convert/util.dart';

class Site {
  static final String api = 'https://api.ifelse.co/mobile/v1/',
    version = '0.1.0';

  static final log = Logger();
  static int id = 0;
  static String name = '',
    domain = '',
    token = '',
    session = '';
  static double dpi = 1;
  static Map<String, dynamic> template = {};
  static List<Widget> pageType = <Widget>[],
    pageTab = <Widget>[];

  static void getData(dynamic load, BuildContext buildContext) {
    id = getInt(load['_id']);
    name = load['name'];
    domain = load['domain'];
    ['splash','login','home','articles','article','products','product','cart','jobs','job'].forEach((v) {
      template[v] = load['theme'][v];
    });
  }
} 
