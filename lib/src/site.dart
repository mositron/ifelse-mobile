import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'convert/cache.dart';
import 'bloc/cart.dart';

class Site {
  static final String api = 'https://api.ifelse.co/mobile/v1/',
    version = '0.1.0';
  static int id = 0;
  static String name = '',
    domain = '',
    token = '',
    font = 'Kanit',
    fcm = '',
    os = '';
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
      cacheSaveList('template-'+v, load['theme'][v]);
    });
    if((load['articles'] != null) && (load['articles'] is List)) {
      articles = load['articles'];
    }
    if((load['products'] != null) && (load['products'] is List)) {
      products = load['products'];
    }
  }

  static Map<int,dynamic> orderStatus = {
    -2: {'name':'ยกเลิกโดยลูกค้า','badge':'dark','text':'dark','code':'customer','icon':'close-squared-alt'},
    -1: {'name':'ยกเลิกโดยร้านค้า','badge':'secondary','text':'secondary','code':'store','icon':'close-circled'},
    0: {'name':'รอชำระเงิน','badge':'light','text':'black','code':'payment','icon':'credit-card'},
    1: {'name':'รอตรวจสอบ','badge':'warning','text':'warning','code':'confirm','icon':'waiter-alt'},
    2: {'name':'รอส่ง','badge':'info','text':'info','code':'delivery','icon':'truck-loaded'},
    3: {'name':'ส่งสินค้าแล้ว','badge':'success','text':'success','code':'success','icon':'check-circled'},
  };
} 
