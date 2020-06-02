import 'package:flutter/widgets.dart';
//import 'convert/align.dart';
import '../layer.dart';
import 'util.dart';
import 'gradient.dart';
import 'border.dart';
import 'shadow.dart';
import 'edge.dart';

Widget getSplit(int col, String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
  List<dynamic> child = map['child'];
  dynamic box = getVal(map,'box');
  dynamic data = getVal(map,'data');
  EdgeInsets inPadding = getEdgeInset(getVal(data,'box.padding'));
  List<Widget> widget = [];
  if(col == 1) {
      widget.add(Container(
        padding: inPadding,
        child: Column(
          children: (child.length > 0 ? Layer.build(file, child[0], buildContext, par, func) : null)
        )
      )
    );
  } else {
    for(int i=0; i<col; i++) {
      widget.add(
        Expanded(          
          child: Container(
            padding: inPadding,
            child: Column(
            children: (child.length > i ? Layer.build(file, child[i], buildContext, par, func) : null)
          )
          )
        )
      );
    }    
  }
  dynamic flex = getVal(data,'flex');
  String width = getVal(flex,'width').toString();
  BoxConstraints boxwidth = BoxConstraints();
  //Alignment align = Alignment.center;
  if(width == 'pixel') {
    boxwidth = BoxConstraints(maxWidth: getDouble(getVal(flex,'pixel')));
    //align = getAlignBox(getVal(flex,'align'));
  }
  return Center(
      child: ConstrainedBox(
        constraints: boxwidth,
        child: Container(
          alignment: Alignment.center,    
          decoration: BoxDecoration(
            gradient: getGradient(getVal(box,'bg.color')),
            borderRadius: getBorderRadius(getVal(box,'border')),
            boxShadow: getBoxShadow(getVal(box,'shadow')),
          ),
          margin: getEdgeInset(getVal(box,'margin')),
          //padding: getEdgeInset(getVal(box,'padding')),
          child: CustomPaint(
            //size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
            painter: DrawCurve(getVal(box,'bg.color')),
            child: Container(
              padding: getEdgeInset(getVal(box,'padding')),
              child: col == 1 ? 
                widget[0] : 
                Row(
                  children: widget
                )
            )
          ),
        )
      )
  );
}