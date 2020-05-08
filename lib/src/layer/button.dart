import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifelse/src/convert/image.dart';
import 'package:logger/logger.dart';
import '../layer.dart';
import '../convert/util.dart';
import '../convert/align.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/icon.dart';
import '../convert/shadow.dart';

class ButtonParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    String align = getVal(data,'align').toString();    
    List<Widget> widget = [];
    widget = [
      Icon(
        getIcon(getVal(data,'icon')),
        color: Colors.white,
        size: 16,
      ),
      SizedBox(width: 8),
      Text(
        getVal(data,'text'),
        style: TextStyle(color:getColor(getVal(data,'color')),fontFamily: 'Kanit',fontSize: getDouble(getVal(data,'size') ?? 16))
      ),
    ];
    return Center(      
      child: Container(
        margin: getEdgeInset(getVal(box,'margin')),
        padding: EdgeInsets.all(0),
        alignment: getAlignBox(align),
        decoration: BoxDecoration(
          borderRadius: getBorderRadius(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),      
        child: RawMaterialButton(
          onPressed: ()=>{},
          padding: EdgeInsets.all(0.0),
          elevation: 0.0,     
          child: Ink(            
            width: align == 'full' ? double.infinity : null,
            decoration: BoxDecoration(
              gradient: getGradient(getVal(box,'bg.color')),
              borderRadius: getBorderRadius(getVal(box,'border')),
              border: getBorder(getVal(box,'border')),
              image: getImageBG(getVal(box,'bg')),
              boxShadow: getBoxShadow(getVal(box,'shadow')),
            ),
            padding: getEdgeInset(getVal(box,'padding')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              mainAxisSize: MainAxisSize.min,
              children: widget,
            )
          )
        )
      )
    );
  }

  @override
  String get widgetName => 'button';
}
