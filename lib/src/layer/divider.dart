
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/align.dart';

class DividerParser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    double height = getDouble(getVal(data,'height')),
      width = getDouble(getVal(data,'width'));
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: getAlignBox(getVal(data,'align')),
      child: FractionallySizedBox(
        widthFactor: width / 100,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: getGradient(getVal(data,'color')),
          ),
        ),
      )
    );
  }
  @override
  String get widgetName => 'divider';
}
