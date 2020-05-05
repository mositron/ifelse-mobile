import 'package:flutter/material.dart';
import 'util.dart';

EdgeInsetsGeometry getEdgeInset(dynamic rad) {
  if ((rad != null) && (rad is! List)) {
    return EdgeInsets.only(
      top: getDPI(rad['top']),
      right: getDPI(rad['right']),
      bottom: getDPI(rad['bottom']),
      left: getDPI(rad['left']),
    );
  }
  return EdgeInsets.zero;
}
