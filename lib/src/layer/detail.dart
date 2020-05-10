
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/editor.dart';

class DetailParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: Column(
        children: getEditor(par['editor']),
      )
    );
  }
  @override
  String get widgetName => 'detail';
}
