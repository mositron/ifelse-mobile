import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'convert/cache.dart';
import 'bloc/cart.dart';

class Site {
  static final String api = 'https://api.ifelse.co/mobile/v1/',
    version = '0.1.0';
  static final log = Logger();
  static int id = 0;
  static String name = '',
    domain = '',
    token = '',
    font = 'Kanit';
  static double fontSize = 16;
  static Map<String, dynamic> template = {};
  static List<dynamic> articles = [],
    products = [],
    cart = [];
  static List<Widget> pageType = <Widget>[],
    pageTab = <Widget>[];
  static CartBloc cartBloc;

  static void setData(dynamic load) {
    name = load['name'];
    domain = load['domain'];
    ['splash','login','home','articles','article','products','product','cart','jobs','job'].forEach((v) {
      template[v] = load['theme'][v];
      cacheSaveTemplate(v, load['theme'][v]);
    });
    if((load['articles'] != null) && (load['articles'] is List)) {
      articles = load['articles'];
    }
    if((load['products'] != null) && (load['products'] is List)) {
      products = load['products'];
    }
  }
} 
