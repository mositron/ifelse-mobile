
import 'package:flutter/material.dart';
import 'gradient.dart';

Widget getLoading() {
  return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: getGradient({'color1':'fff','color2':'fff','range':1,'gragient':2}),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),                      
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
          ),
      )
    )
  );
}