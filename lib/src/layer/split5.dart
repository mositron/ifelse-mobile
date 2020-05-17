
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';

class Split5Parser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return getSplit(5, file, map, buildContext, par, func);
  }

  @override
  String get widgetName => 'split5';
}
