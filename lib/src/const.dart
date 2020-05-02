import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Site {
  static String api = 'https://api.ifelse.co/mobile/v1/';
  static String token = '';
  static String version = '0.1.0';
  static int appBg = 0;
  static Color appBg1;
  static Color appBg2;
  static int appRange = 0;
  
  static int navPos = 0;
  static String navType = 'name';
  static String navImage = '';
  static String navName = '';
  static Color navTxt;  
  static int navBg = 0;
  static Color navBg1;
  static Color navBg2;
  static int navRange = 0;
  static int navShadow = 0;

  static Color menuTxt;
  static Color menuFocus;
  static int menuBg = 0;
  static Color menuBg1;
  static Color menuBg2;
  static int menuRange = 0;
  static String menuType = 'bottom';
  
  static Color bodyTxt;
  static int bodyBg = 0;
  static Color bodyBg1;
  static Color bodyBg2;
  static int bodyRange = 0;
  static double bodyMLeft = 0;
  static double bodyMRight = 0;
  static double bodyMTop = 0;
  static double bodyMBottom = 0;
  static double bodyPLeft = 0;
  static double bodyPRight = 0;
  static double bodyPTop = 0;
  static double bodyPBottom = 0;
  static double bodyRD1 = 0;
  static double bodyRD2 = 0;
  static double bodyRD3 = 0;
  static double bodyRD4 = 0;
  
  static String cardType = '';
  static Color cardTxt;
  static int cardBg = 0;
  static Color cardBg1;
  static Color cardBg2;
  static int cardRange = 0;
  static double cardRD1 = 0;
  static double cardRD2 = 0;
  static double cardRD3 = 0;
  static double cardRD4 = 0;
  static int cardShadow = 0;

  //static List<BottomNavigationBarItem> pageBar = <BottomNavigationBarItem>[];
  //static List<Map<String,String>> pageBody = <Map<String,String>>[];
  static List<Widget> pageType = <Widget>[];
  static List<Widget> pageTab = <Widget>[];

  static void getData(dynamic load) {
    Site.appBg = getInt(load['app']['bg']);
    Site.appBg1 = HexColor(load['app']['bg1'], '#ffffff');
    Site.appBg2 = HexColor(load['app']['bg2'], '#ffffff');
    Site.appRange = getInt(load['app']['range']);
    
    Site.navPos = getInt(load['nav']['pos']);
    Site.navType = load['nav']['type'];
    Site.navImage = load['nav']['image'];
    Site.navName = load['nav']['name'];
    Site.navTxt = HexColor(load['nav']['txt'], '#ffffff');
    Site.navBg = getInt(load['nav']['bg']);
    Site.navBg1 = HexColor(load['nav']['bg1'], '#ffffff');
    Site.navBg2 = HexColor(load['nav']['bg2'], '#ffffff');
    Site.navRange = getInt(load['nav']['range']);
    Site.navShadow = getInt(load['nav']['shadow']);

    Site.menuType = load['menu']['type'];
    Site.menuTxt = HexColor(load['menu']['txt'], '#444444');
    Site.menuFocus = HexColor(load['menu']['focus'], '#ff4400');
    Site.menuBg = getInt(load['menu']['bg']);
    Site.menuBg1 = HexColor(load['menu']['bg1'], '#ffffff');
    Site.menuBg2 = HexColor(load['menu']['bg2'], '#ffffff');
    Site.menuRange = getInt(load['menu']['range']);

    Site.bodyTxt = HexColor(load['body']['txt'], '#444444');
    Site.bodyBg = getInt(load['body']['bg']);
    Site.bodyBg1 = HexColor(load['body']['bg1'], '#ffffff');
    Site.bodyBg2 = HexColor(load['body']['bg2'], '#ffffff');
    Site.bodyRange = getInt(load['body']['range']);
    Site.bodyMLeft = getDouble(load['body']['mleft']);
    Site.bodyMRight = getDouble(load['body']['mright']);
    Site.bodyMTop = getDouble(load['body']['mtop']);
    Site.bodyMBottom = getDouble(load['body']['mbottom']);
    Site.bodyPLeft = getDouble(load['body']['pleft']);
    Site.bodyPRight = getDouble(load['body']['pright']);
    Site.bodyPTop = getDouble(load['body']['ptop']);
    Site.bodyPBottom = getDouble(load['body']['pbottom']);
    Site.bodyRD1 = getDouble(load['body']['rd1']);
    Site.bodyRD2 = getDouble(load['body']['rd2']);
    Site.bodyRD3 = getDouble(load['body']['rd3']);
    Site.bodyRD4 = getDouble(load['body']['rd4']);

    Site.cardType = load['card']['type'];
    Site.cardTxt = HexColor(load['card']['txt'], '#444444');
    Site.cardBg = getInt(load['card']['bg']);
    Site.cardBg1 = HexColor(load['card']['bg1'], '#ffffff');
    Site.cardBg2 = HexColor(load['card']['bg2'], '#ffffff');
    Site.cardRange = getInt(load['card']['range']);
    Site.cardRD1 = getDouble(load['card']['rd1']);
    Site.cardRD2 = getDouble(load['card']['rd2']);
    Site.cardRD3 = getDouble(load['card']['rd3']);
    Site.cardRD4 = getDouble(load['card']['rd4']);
    Site.cardShadow = getInt(load['card']['shadow']);
  }

  static double getDouble(dynamic val) => (val == null) ? 0.0 : val.toDouble();
  static int getInt(dynamic val) => (val == null) ? 0 : val.toInt();  
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor, String defaultColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 3) {
      String tmp = "";
      for(int i=0;i<3;i++) {
        var h = hexColor.substring(i,i+1);
        tmp += h + h;
      }
      hexColor = "FF" + tmp;
    } else if (hexColor.length == 4) {
      String tmp = "";
      for(int i=0;i<4;i++) {
        var h = hexColor.substring(i,i+1);
        tmp += h + h;
      }
      hexColor = tmp.substring(6,8) + tmp.substring(0,6);
    } else if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    } else if (hexColor.length == 8) {
      hexColor = hexColor.substring(6,8) + hexColor.substring(0,6);
    } else {
      hexColor = "FF" + defaultColor.toUpperCase().replaceAll("#", "");
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, final String defaultColor) : super(_getColorFromHex(hexColor, defaultColor));
}