
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';


class HeadingParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    dynamic box = getVal(map,'box');
    dynamic data = getVal(map,'data');
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border.radius'))
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'bg.padding')),
      alignment: Alignment(0.0, 0.0),
      child: Text(
        getVal(data,'text'),
        style: TextStyle(fontFamily: 'Kanit',fontSize: 16)
      )
    );
      
  }

  @override
  String get widgetName => "heading";
}
