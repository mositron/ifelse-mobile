import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';

class Split2Parser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return getSplit(2, file, map, buildContext, par, func);
  }

  @override
  String get widgetName => 'split2';
}
