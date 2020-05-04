import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../layer.dart';
import '../convert/util.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/icon.dart';
import '../convert/shadow.dart';


class ButtonParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    dynamic box = getVal(map,'box');
    dynamic data = getVal(map,'data');
    BorderRadius radius = getBorderRadius(getVal(data,'border.radius'));
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border.radius'))
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      child: RawMaterialButton(
        onPressed: ()=>{},
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: getGradient(getVal(data,'color.bg')),
            borderRadius: radius,
            boxShadow: getBoxShadow(getVal(data,'shadow')),
          ),
          padding:getEdgeInset(getVal(data,'border.space')),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                getIcon(getVal(data,'icon')),
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                map['data']['text'],
                style: TextStyle(color:getColor(getVal(data,'normal.text')),fontFamily: 'Kanit',fontSize: 16)
              ),
            ],
          )
        )
      )
    );
  }

  @override
  String get widgetName => 'button';
}
