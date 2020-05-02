import '../layer.dart';
import '../convert/image.dart'; 
import '../convert/gradient.dart';
import '../convert/border.dart';
//import '../utils.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../convert/edge.dart';


class ImageParser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(map['box']['bg']['color']),
        borderRadius: getBorderRadius(map['box']['border']['radius'])
      ),
      margin: getEdgeInset(map['box']['margin']),
      padding: getEdgeInset(map['box']['padding']),
      alignment: Alignment(0.0, 0.0),
      child: new Image.network(getImage(map['data']['image'],map['data']['size'])),
    );    
  }

  @override
  String get widgetName => "image";
}
