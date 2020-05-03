import 'package:flutter/material.dart';
import 'util.dart';

EdgeInsetsGeometry getEdgeInset(dynamic rad) {
  if ((rad != null) && !(rad is List)) {
    return EdgeInsets.only(
      top: getDouble(rad['top']),
      right: getDouble(rad['right']),
      bottom: getDouble(rad['bottom']),
      left: getDouble(rad['left']),
    );
  }
  return EdgeInsets.zero;
}
