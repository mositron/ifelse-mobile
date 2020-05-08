import 'package:flutter/material.dart';
import 'util.dart';

Border getBorder(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    Color color = getColor(getVal(rad,'color'),'fff');
    String style = getVal(rad,'style').toString();
    double bTop = getDouble(getVal(rad,'width.top')),
      bRight = getDouble(getVal(rad,'width.right')),
      bBottom = getDouble(getVal(rad,'width.bottom')),
      bLeft = getDouble(getVal(rad,'width.left'));
    if((style == 'solid') && (bTop > 0 || bRight > 0 || bBottom > 0 || bLeft > 0)) {
      return Border(
        top: BorderSide( //                    <--- top side
          color: color,
          width: bTop,
          style: bTop > 0 ? BorderStyle.solid : BorderStyle.none
        ),
        right: BorderSide( //                    <--- top side
          color: color,
          width: bRight,
          style: bRight > 0 ? BorderStyle.solid : BorderStyle.none
        ),
        bottom: BorderSide( //                    <--- top side
          color: color,
          width: bBottom,
          style: bBottom > 0 ? BorderStyle.solid : BorderStyle.none
        ),
        left: BorderSide( //                    <--- top side
          color: color,
          width: bLeft,
          style: bLeft > 0 ? BorderStyle.solid : BorderStyle.none
        )
      );
    }
  }
  return null;
}

BorderRadius getBorderRadius(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    String style = getVal(rad,'style').toString();
    dynamic radius = getVal(rad,'radius');
    if((style == 'radius') && (radius != null) && (radius is! List)) {
      return BorderRadius.only(
        topLeft: Radius.circular(getDouble(radius['top'])),
        topRight: Radius.circular(getDouble(radius['right'])),
        bottomRight: Radius.circular(getDouble(radius['bottom'])),
        bottomLeft: Radius.circular(getDouble(radius['left'])),
      );
    }
  }
  return null;
  //return BorderRadius.zero;
}
