import 'package:flutter/material.dart';
import 'util.dart';

BorderRadius getBorderRadius(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    return BorderRadius.only(
      topLeft: Radius.circular(getDPI(rad['top'])),
      topRight: Radius.circular(getDPI(rad['right'])),
      bottomRight: Radius.circular(getDPI(rad['bottom'])),
      bottomLeft: Radius.circular(getDPI(rad['left'])),
    );
  }
  return BorderRadius.zero;
}
