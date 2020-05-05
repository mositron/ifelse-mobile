import 'package:flutter/widgets.dart';
import 'package:ifelse/src/convert/align.dart';
//import 'package:logger/logger.dart';
import '../layer.dart';
import 'util.dart';
import 'gradient.dart';
import 'border.dart';
import 'shadow.dart';
import 'edge.dart';

Widget getSplit(int col, Map<String, dynamic> map, BuildContext buildContext) {
  //Logger log = Logger();
  List<dynamic> child = map['child'];
  dynamic box = getVal(map,'box');
  dynamic data = getVal(map,'data');
  List<Widget> widget = [];
  if(col == 1) {
      widget.add(Column(
          children: (child.length > 0 ? Layer.build(child[0], buildContext) : null)
        )
      );
  } else {
    for(int i=0; i<col; i++) {
      widget.add(
        Expanded(
          child: Column(
            children: (child.length > i ? Layer.build(child[i], buildContext) : null)
          )
        )
      );
    }    
  }
  dynamic flex = getVal(data,'flex');
  String width = getVal(flex,'width').toString();
  BoxConstraints boxwidth = BoxConstraints();
  Alignment align = Alignment.center;
  if(width == 'pixel') {
    boxwidth = BoxConstraints(maxWidth: getDPI(getVal(flex,'pixel')));
    align = getAlignBox(getVal(flex,'align'));
  }
  return Container(
    child: Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: boxwidth,
        child: Container(
          decoration: BoxDecoration(
            gradient: getGradient(getVal(box,'bg.color')),
            borderRadius: getBorderRadius(getVal(box,'border.radius')),
            boxShadow: getBoxShadow(getVal(box,'shadow')),
          ),
          margin: getEdgeInset(getVal(box,'margin')),
          padding: getEdgeInset(getVal(box,'padding')),
          child: col == 1 ? widget[0] : 
              Row(
                children: widget
              )
        )
      )
    )
  );
}