import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/image.dart'; 
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/click.dart';
import '../convert/icon.dart';

class IconParser extends WidgetParser {

  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      click = getVal(data,'click');
      
    IconData icon = getIcon(getVal(data,'icon'));
    Icon _icon = Icon(icon, color: getColor(getVal(data,'color')), size: getDouble(getVal(data,'size')),);

    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      //padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: CustomPaint(
        //size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
        painter: DrawCurve(getVal(box,'bg.color')),
        child: Container(
          padding: getEdgeInset(getVal(box,'padding')),
          child: GestureDetector(
              child: _icon,
              onTap: () => getClicked(buildContext, click),
            )
        )
      )      
    );    
  }

  @override
  String get widgetName => 'icon';
}
