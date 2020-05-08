
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';

class Split6Parser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    return getSplit(6, map, buildContext);
  }

  @override
  String get widgetName => 'split6';
}
