
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/align.dart';

class RequestParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    String text = getVal(par,'request') ?? '';
    double fsize = getDouble(getVal(data,'size'), 16);
    Color color = getColor(getVal(data,'color'));
    TextAlign align = getAlignText(getVal(data,'align'));    
    List<Widget> list = [];
    List<String> line = text.split('\n');
    if(line.length > 0) {
      for(int i=0; i<line.length; i++) {
        list.add(
          Container(
            margin: EdgeInsets.only(bottom:5),
            alignment: Alignment.centerLeft,
            child: Text(
              '• ' + line[i],
              style: TextStyle(fontFamily: 'Kanit',fontSize: fsize, color: color),
              textAlign: align,
            )
          )
        );
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
      child: Column(        
        children: list
      )
    );
  }
  @override
  String get widgetName => 'request';
}
