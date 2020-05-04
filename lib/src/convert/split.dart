import 'package:flutter/widgets.dart';
//import 'package:logger/logger.dart';
import '../layer.dart';
import 'util.dart';
import 'gradient.dart';
import 'border.dart';
import 'edge.dart';


Widget getSplit(int col, Map<String, dynamic> map, BuildContext buildContext) {
  List<dynamic> child = map['child'];
  dynamic box = getVal(map,'box');
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
  return Container(
    child: Align(
      alignment: Alignment.bottomRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(/*minWidth: 100.0, maxWidth: 300.0*/),
        child: Container(
          decoration: BoxDecoration(
            gradient: getGradient(getVal(box,'bg.color')),
            borderRadius: getBorderRadius(getVal(box,'border.radius'))
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