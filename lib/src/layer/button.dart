import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/color.dart';

import '../layer.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';


class ButtonParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(map['box']['bg']['color']),
        borderRadius: getBorderRadius(map['box']['border']['radius'])
      ),
      margin: getEdgeInset(map['box']['margin']),
      padding: getEdgeInset(map['box']['padding']),
      child: RawMaterialButton(
        onPressed: ()=>{},
        shape: RoundedRectangleBorder(borderRadius: getBorderRadius(map['data']['border']['radius'])),
        
        //margin: getEdgeInset(map['box']['margin']),
        padding: EdgeInsets.all(0.0),
        //child: SizedBox(
         // width: double.infinity,
          child: Ink(
            decoration: BoxDecoration(
              gradient: getGradient(map['data']['normal']['bg']),
              borderRadius: getBorderRadius(map['data']['border']['radius'])
            ),
            child: Container(
              //data.space.width
              padding: getEdgeInset(map['data']['space']),
              //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                map['data']['text'],
                style: TextStyle(color:getColor(map['data']['normal']['text']))
              )
         //   )
          )
        )
      )
    );
  }

  @override
  String get widgetName => "button";
}
