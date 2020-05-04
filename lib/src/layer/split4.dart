
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';


class Split4Parser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    return getSplit(4, map, buildContext);
  }

  @override
  String get widgetName => 'split4';
}
