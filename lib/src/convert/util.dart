
import 'package:flutter/material.dart';

int getInt(dynamic val, [int def]) {
  //final log = Logger();
  if ((val == null) || (val.toString().isEmpty)) {
    return def ?? 0;
  } else if(val is int) {
    return val;
  } 
  return int.parse(val);
}

double getDouble(dynamic val, [double def]) {
  if ((val == null) || (val.toString().isEmpty)) {
    return def ?? 0.0;
  } else if(val is int) {
    return val.toDouble();
  } else if(val is double) {
    return val;
  }
  return double.parse(val);
}

Color getColor(String hex, [String def]) {
  if(hex is! String) {
    return Colors.black;
  }
  hex = hex.toUpperCase().replaceAll('#', '');
  if (hex.length == 3) {
    String tmp = '';
    for (int i = 0; i < 3; i++) {
      var h = hex.substring(i, i + 1);
      tmp += h + h;
    }
    hex = 'FF' + tmp;
  } else if (hex.length == 4) {
    String tmp = '';
    for (int i = 0; i < 4; i++) {
      var h = hex.substring(i, i + 1);
      tmp += h + h;
    }
    hex = tmp.substring(6, 8) + tmp.substring(0, 6);
  } else if (hex.length == 6) {
    hex = 'FF' + hex;
  } else if (hex.length == 8) {
    hex = hex.substring(6, 8) + hex.substring(0, 6);
  } else if(def.length >= 3) {
    return getColor(def);
  } else {
    hex = 'FF000000';
  }
  return Color(int.parse(hex, radix: 16));
}

dynamic getVal(dynamic obj, String key) {
  if((obj != null) && (obj is Map)) {
    List<String> point = key.split('.');
    String cur = point.removeLast();
    while(point.length > 0) {
      String start = point.removeAt(0);
      obj = obj[start]  = obj[start] ?? new Map();
    }
    if((obj != null) && (obj is Map)) {
      return obj[cur];
    }
  }
  return null;
}

double getRatio(String size) {
  switch(size) {
    case '1by1':
      return 1;
    case '2by3':
      return 2/3;
    case '3by2':
      return 3/2;
    case '16by9':
      return 16/9;
    case '21by9':
      return 21/9;
    default:
      return 0;
  }
}