import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/align.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/icon.dart';
import '../convert/shadow.dart';
import '../convert/image.dart';
import '../convert/click.dart';
import '../convert/util.dart';

class ButtonParser extends WidgetParser {
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return ButtonView(key: UniqueKey(), file: file, map: map, buildContext: buildContext, par: par, func: func);    
  }
  
  @override
  String get widgetName => 'button';
}

class ButtonView extends StatefulWidget {
  final dynamic map;
  final BuildContext buildContext;
  final String file;
  final dynamic par;
  final Function func;
  ButtonView({Key key, this.file, this.map, this.buildContext, this.par, this.func}) : super(key: key);

  @override
  ButtonViewState createState() {
    return ButtonViewState(file, map, buildContext, par, func);
  }
}
 
class ButtonViewState extends State<ButtonView> {
  bool loaded;
  dynamic _map;
  String _file;
  BuildContext buildContext;
  dynamic _par;
  Function _func;
  ButtonViewState(this._file, this._map, this.buildContext, this._par, this._func);

  @override
  Widget build(BuildContext context) {
    dynamic box = getVal(_map,'box'),
      data = getVal(_map,'data'),
      tmp = getVal(data,'click');
    Map<String, dynamic> click;
    String align = getVal(data,'align').toString(),
      ipos = getVal(data,'ipos').toString(),
      spec = getVal(_map,'spec');
    Color _color = getColor(getVal(data,'color'));
    double _fSize = getDouble(getVal(data,'size') ?? Site.fontSize);
    List<Widget> widget = [];
    IconData icon = getIcon(getVal(data,'icon'));
    String text = getVal(data,'text').toString();
    Icon _icon = Icon(icon, color: _color, size: _fSize,);
    Text _text = Text(text, style: TextStyle(color:_color,fontFamily: Site.font, fontSize: _fSize));
    
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
    return Align(
      alignment: getAlignBox(align),
      child: Container(
        width: align == 'full' ? double.infinity : null,
        margin: getEdgeInset(getVal(box,'margin')),
        padding: EdgeInsets.all(0),
        //alignment: getAlignBox(align),
        decoration: BoxDecoration(
          borderRadius: getBorderRadius(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),
        child: RawMaterialButton(
          onPressed: () {
            if(_file == 'login') {
              if((spec == 'google') || (spec == 'facebook')) {
                click = {'type':spec};
                if(_func is Function) {
                  _func(spec);
                }
              }
            } else if(_file == 'product') {
              if(spec == 'cart') {
                if(_func is Function) {
                  _func('button');
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
            ),
            child: CustomPaint(
              //size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
              painter: DrawCurve(getVal(box,'bg.color')),
              child: Container(
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
              ),
            ),
          )
        )
      )
    );
  }
}
