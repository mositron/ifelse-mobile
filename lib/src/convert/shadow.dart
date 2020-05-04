import 'package:flutter/material.dart';
import 'util.dart';

List<BoxShadow> getBoxShadow(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    String color = getVal(rad,'color').toString();
    double blur = getDouble(getVal(rad,'blur'));
    if(color.isNotEmpty && blur > 0) {
      return [
        BoxShadow(
          color: getColor(color),
          blurRadius: blur,
          spreadRadius: getDouble(getVal(rad,'spread')),
          offset: Offset(
            getDouble(getVal(rad,'x')),
            getDouble(getVal(rad,'y')),
          ),
        )
      ];
    }
  }
  return null;
}
