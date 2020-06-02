import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/image.dart'; 
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/click.dart';

class ImageParser extends WidgetParser {

  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      click = getVal(data,'click');
    Map image = getImageObj(getVal(data,'image'),getVal(data,'size'));
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
          child: image != null ?
            GestureDetector(
              child: getImageWidget(image['src']),
              onTap: () => getClicked(buildContext, click),
            ) : 
            null,
        )
      )      
    );    
  }

  @override
  String get widgetName => 'image';
}
