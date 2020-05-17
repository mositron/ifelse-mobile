import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/split.dart';

class Split1Parser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    return getSplit(1, file, map, buildContext, par);
  }

  @override
  String get widgetName => 'split1';
}
