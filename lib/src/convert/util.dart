
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';

String getString(dynamic val, [String def]) {
  //final log = Logger();
  String to = '';
  if ((val == null) || (val.toString().isEmpty)) {
    to = def ?? '';
  } else {
    to = val.toString();
  }
  return HtmlUnescape().convert(to);
}

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

String getCurrency(dynamic val, [double def]) {
  double currency = getDouble(val, def);
  if(currency > 0) {
    return currency.toStringAsFixed(2).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
  return '';
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

String getTime(dynamic time, String format) {
  if(time != null) {
    if((time is Map) && (time['milliseconds'] != null)) {
      var date = new DateTime.fromMillisecondsSinceEpoch(getInt(time['milliseconds']));
      return DateFormat('y-MM-d HH:mm').format(date);
    }
  }
  return '';
}