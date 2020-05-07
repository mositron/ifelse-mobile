import 'dart:math';

import 'package:flutter/material.dart';
import '../site.dart';
import 'util.dart';

String getImage(dynamic obj, [String size, String service]) {
  if ((obj != null) && (obj is! List)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {      
      return 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + obj[size]['ext'];
    }
  }
  return null;
}

dynamic getImageObj(dynamic obj, [String size, String service]) {
  if ((obj != null) && (obj is! List)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {      
      return {
        'src': 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + obj[size]['ext'],
        'ext': obj[size]['ext'],
        'size': size,
        'width': obj[size]['w'],
        'height': obj[size]['h'],
      };
    }
  }
  return null;
}



DecorationImage getImageBG(dynamic obj) {
  if ((obj != null) && (obj is! List)) {
    dynamic img =  getImageObj(obj['image'],'o');
    Site.log.w(obj);
    Site.log.w(img);
    BoxFit bfit = BoxFit.none;
    switch(obj['size'].toString()) {
      case 'cover':
        bfit = BoxFit.cover;
        break;
      case 'contain':
        bfit = BoxFit.contain;
        break;
    }
    if(img != null) {
      return DecorationImage(
        image: Image.network(img['src'], width: getDouble(img['width']), height: getDouble(img['height'])).image,
        fit: bfit
      );
    }
  }
  return null;
}