import 'package:flutter/material.dart';
import 'util.dart';

Gradient getGradient(dynamic obj) {
  List<Color> colors = [];
  if ((obj != null) && (obj is! List)) {
    if ((obj['color1'] != null) && (obj['color1'].toString().isNotEmpty)) {
      colors.add(getColor(obj['color1']));
    }
    if (getInt(obj['gradient']) > 1) {
      if ((obj['color2'] != null) && (obj['color2'].toString().isNotEmpty)) {
        colors.add(getColor(obj['color2']));
      }
    }
    if (colors.length == 1) {
      colors.add(colors[0]);
    }
    if (colors.length == 2) {
      AlignmentGeometry begin = Alignment.centerLeft,
        end = Alignment.centerRight;
      switch (getInt(obj['range'])) {
        case 0:
          begin = Alignment.bottomCenter;
          end = Alignment.topCenter;
          break;
        case 45:
          begin = Alignment.bottomLeft;
          end = Alignment.topRight;
          break;
        case 90:
          begin = Alignment.centerLeft;
          end = Alignment.centerRight;
          break;
        case 135:
          begin = Alignment.topLeft;
          end = Alignment.bottomRight;
          break;
        case 180:
          begin = Alignment.topCenter;
          end = Alignment.bottomCenter;
          break;
        case 225:
          begin = Alignment.topRight;
          end = Alignment.bottomLeft;
          break;
        case 270:
          begin = Alignment.centerRight;
          end = Alignment.centerLeft;
          break;
        case 315:
          begin = Alignment.bottomRight;
          end = Alignment.topLeft;
          break;
          break;
      }
      return LinearGradient(colors: colors, begin: begin, end: end);
    }
  }
  return null;
}
