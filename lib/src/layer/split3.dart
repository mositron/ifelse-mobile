import '../layer.dart';
import '../convert/gradient.dart';
import '../convert/border.dart';
//import '../utils.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../convert/edge.dart';


class Split3Parser extends WidgetParser {
  static final log = Logger();

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    List<dynamic> child = map['child'];
    //log.i(child);
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(map['box']['bg']['color']),
        borderRadius: getBorderRadius(map['box']['border']['radius'])
      ),
      margin: getEdgeInset(map['box']['margin']),
      padding: getEdgeInset(map['box']['padding']),
      child: Row(
        children: [
          Column(
            children: (child.length > 0 ? Layer.build(child[0], buildContext) : null)
          ) ,
          Column(
            children: (child.length > 1 ? Layer.build(child[1], buildContext) : null)
          ) ,
          Column(
            children: (child.length > 2 ? Layer.build(child[2], buildContext) : null)
          ) 
        ]
      )  
    );
  }

  @override
  String get widgetName => "split3";
}
