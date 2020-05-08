import 'package:flutter/material.dart';
import 'util.dart';

Alignment getAlign(dynamic align) {
  Alignment alignment = Alignment.center;
  switch (align.toString()) {
    case '':
      alignment = Alignment.center;
      break;
    case 'top left':
      alignment = Alignment.topLeft;
      break;
    case 'top center':
      alignment = Alignment.topCenter;
      break;
    case 'top right':
      alignment = Alignment.topRight;
      break;
    case 'center right':
      alignment = Alignment.centerRight;
      break;
    case 'bottom right':
      alignment = Alignment.bottomRight;
      break;
    case 'bottom center':
      alignment = Alignment.bottomCenter;
      break;
    case 'bottom left':
      alignment = Alignment.bottomLeft;
      break;
    case 'center left':
      alignment = Alignment.centerLeft;
      break;
  }
  return alignment;
}

Alignment getAlignBox(dynamic align) {
  Alignment alignment = Alignment.center;
  switch (align) {
    case 'left':
      alignment = Alignment.centerLeft;
      break;
    case 'right':
      alignment = Alignment.centerRight;
      break;
  }
  return alignment;
}

TextAlign getAlignText(dynamic align) {
  TextAlign alignment = TextAlign.left;
  switch (align) {
    case 'center':
      alignment = TextAlign.center;
      break;
    case 'right':
      alignment = TextAlign.right;
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
