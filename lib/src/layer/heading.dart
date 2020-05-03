import '../layer.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';


class HeadingParser extends WidgetParser {
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
      child: Text(
        map['data']['text'],
        style: TextStyle(fontFamily: 'Kanit',fontSize: 16)
      )
    );
      
  }

  @override
  String get widgetName => "heading";
}
