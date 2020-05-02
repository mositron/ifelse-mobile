import 'package:flutter/material.dart';
import 'double.dart';


Gradient getGradient (dynamic rad) {  
  List<Color> c = [];
  
  Gradient d = Gradient(colors: c)
  if((rad != null) && !(rad is List)) {
    return BorderRadius.only(
      topLeft: Radius.circular(getDouble(rad['top'])),
      topRight: Radius.circular(getDouble(rad['right'])),
      bottomRight: Radius.circular(getDouble(rad['bottom'])),
      bottomLeft: Radius.circular(getDouble(rad['left'])),
    );
  }
  return BorderRadius.zero;
}
