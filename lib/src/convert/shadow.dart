import 'package:flutter/material.dart';
import 'util.dart';

List<BoxShadow> getBoxShadow(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    String color = getVal(rad,'color').toString();
    double blur = getDPI(getVal(rad,'blur'));
    if(color.isNotEmpty && blur > 0) {
      return [
        BoxShadow(
          color: getColor(color),
          blurRadius: blur,
          spreadRadius: getDPI(getVal(rad,'spread')),
          offset: Offset(
            getDPI(getVal(rad,'x')),
            getDPI(getVal(rad,'y')),
          ),
        )
      ];
    }
  }
  return null;
}
