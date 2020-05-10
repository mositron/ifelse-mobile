import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/image.dart'; 
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';

class ImageParser extends WidgetParser {

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data');
    Map image = getImageObj(getVal(data,'image'),getVal(data,'size'));
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: 
        image != null ? getImageWidget(image['src']) : null,
    );    
  }

  @override
  String get widgetName => 'image';
}
