import 'package:flutter/material.dart';
import 'util.dart';

List<BoxShadow> getBoxShadow(dynamic rad) {
  if ((rad != null) && (rad is Map)) {
    String color = getVal(rad,'color').toString();
    double blur = getDouble(getVal(rad,'blur'),0.0);
    double spread = getDouble(getVal(rad,'spread'),0.0);
    double x = getDouble(getVal(rad,'x'),0.0);
    double y = getDouble(getVal(rad,'y'),0.0);
    /*
    blur = 5;
    spread = 5;
    x = 1;
    y = 1;
    print('color - '+color.toString());
    print('blur - '+blur.toString());
    print('spread - '+spread.toString());
    print('x - '+x.toString());
    print('y - '+y.toString());
    */
    if(color.isNotEmpty && blur > 0) {
      return [
        BoxShadow(
          color: getColor(color),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(x, y),
        )
      ];
    }
  }
  return null;
}
