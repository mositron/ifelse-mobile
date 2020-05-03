import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../layer.dart';
import '../convert/util.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/icon.dart';


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
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: getGradient(map['data']['normal']['bg']),
            borderRadius: getBorderRadius(map['data']['border']['radius'])
          ),
          padding:getEdgeInset(map['data']['space']),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                getIcon(map['data']['icon']),
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                map['data']['text'],
                style: TextStyle(color:getColor(map['data']['normal']['text']),fontFamily: 'Kanit',fontSize: 16)
              ),
            ],
          )
        )
      )
    );
  }

  @override
  String get widgetName => "button";
}
