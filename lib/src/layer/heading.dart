
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/align.dart';

class HeadingParser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    String text = getVal(data,'text');
    String spec = getVal(map, 'spec');
    if(spec == 'auto') {
      if(par is Map) {
        if((par['title'] is String) && (par['title'].toString().isNotEmpty)) {
          text = par['title'];
        } else if((par['text'] is String) && (par['text'].toString().isNotEmpty)) {
          text = par['text'];
        }
      }
    }
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(fontFamily: 'Kanit',fontSize: getDouble(getVal(data,'size'), 16),color: getColor(getVal(data,'color'))),
          textAlign: getAlignText(getVal(data,'align')),
        )
      )
    );
  }
  @override
  String get widgetName => 'heading';
}
