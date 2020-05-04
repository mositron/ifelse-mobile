
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

int getInt(dynamic val, [int def]) {
  final log = Logger();
  if ((val == null) || (val.toString().isEmpty)) {
    return def == null ? 0 : def;
  }
  log.e(val);
  return int.parse(val);
}

double getDouble(dynamic val, [double def]) {
  if ((val == null) || (val.toString().isEmpty)) {
    return def == null ? 0 : def;
  } else if(val is int) {
    return val.toDouble();
  }
  return double.parse(val);
}

Color getColor(String hex, [String def]) {
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
  } else {
    hex = 'FF' + def.toUpperCase().replaceAll('#', '');
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