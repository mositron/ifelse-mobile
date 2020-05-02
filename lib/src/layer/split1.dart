import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
//import '../utils.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../convert/edge.dart';


class Split1Parser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    List<dynamic> child = map['child'];
    return Container(
          decoration: BoxDecoration(
            gradient: getGradient(map['box']['bg']['color']),
            borderRadius: getBorderRadius(map['box']['border']['radius'])
          ),
          margin: getEdgeInset(map['box']['margin']),
          padding: getEdgeInset(map['box']['padding']),
          child: Column(
            children: Layer.build(child[0], buildContext)      
          )  
    );
  }

  @override
  String get widgetName => "split1";
}
