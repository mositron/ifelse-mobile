import 'package:flutter/material.dart';
import 'util.dart';

Alignment getAlign(dynamic align) {
  Alignment alignment = Alignment.center;
  switch (getInt(align)) {
    case 0:
      alignment = Alignment.center;
      break;
    case 1:
      alignment = Alignment.topLeft;
      break;
    case 2:
      alignment = Alignment.topCenter;
      break;
    case 3:
      alignment = Alignment.topRight;
      break;
    case 4:
      alignment = Alignment.centerRight;
      break;
    case 5:
      alignment = Alignment.bottomRight;
      break;
    case 6:
      alignment = Alignment.bottomCenter;
      break;
    case 7:
      alignment = Alignment.bottomLeft;
      break;
    case 8:
      alignment = Alignment.centerLeft;
      break;
  }
  return alignment;
}

MainAxisAlignment getAlignMain(dynamic align) {
  MainAxisAlignment alignment = MainAxisAlignment.start;
  switch (getInt(align)) {
    case 1:
      alignment = MainAxisAlignment.center;
      break;
    case 2:
      alignment = MainAxisAlignment.end;
      break;
    default:
      alignment = MainAxisAlignment.start;
      break;
  }
  return alignment;
}
