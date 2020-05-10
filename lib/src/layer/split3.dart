
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';

class Split3Parser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    return getSplit(3, map, buildContext, par);
  }

  @override
  String get widgetName => 'split3';
}
