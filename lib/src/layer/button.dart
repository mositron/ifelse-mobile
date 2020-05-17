import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifelse/src/site.dart';
import 'package:logger/logger.dart';
import '../layer.dart';
import '../convert/util.dart';
import '../convert/align.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/icon.dart';
import '../convert/shadow.dart';
import '../convert/image.dart';
import '../convert/click.dart';

class ButtonParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      tmp = getVal(data,'click');
    Map<String, dynamic> click;
    String align = getVal(data,'align').toString(),
      ipos = getVal(data,'ipos').toString(),
      spec = getVal(map,'spec');
    Color _color = getColor(getVal(data,'color'));
    double _fSize = getDouble(getVal(data,'size') ?? 16);
    List<Widget> widget = [];
    IconData icon = getIcon(getVal(data,'icon'));
    String text = getVal(data,'text').toString();
    Icon _icon = Icon(icon, color: _color, size: _fSize,);
    Text _text = Text(text, style: TextStyle(color:_color,fontFamily: 'Kanit', fontSize: _fSize));
    
    if(tmp is Map) {
      click = tmp;
    }
    
    if(text.isNotEmpty && icon != null) {
      if(ipos == 'right') {
        widget = [_text, SizedBox(width: 8), _icon,];
      } else if(ipos == 'up') {
        widget = [_icon, SizedBox(height: 3), _text,];
      } else {
        widget = [_icon, SizedBox(width: 8), _text,];
      }
    } else if(text.isNotEmpty) {
      widget = [_text];
    } else if(icon != null) {
      widget = [_icon];
    }
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
          onPressed: () {
            if(file == 'login') {
                print(0);
              if((spec == 'google') || (spec == 'facebook')) {
                click = {'type':spec};
                print(func);
                if(func is Function) {
                  print(2);
                  func(spec);
                }
              }
            }
            getClicked(buildContext, click);
          },
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
            child: ipos == 'up' ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                mainAxisSize: MainAxisSize.min,
                children: widget,
              )
              :
              Row(
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
