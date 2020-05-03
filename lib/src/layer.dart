import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifelse/src/convert/util.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'layer/appbar.dart';
import 'layer/split1.dart';
import 'layer/split2.dart';
import 'layer/image.dart';
import 'layer/heading.dart';
import 'layer/button.dart';
import 'convert/gradient.dart';
import 'convert/align.dart';

class Layer {
  static final Logger log = Logger();

  static final _parsers = [
    Split1Parser(),
    Split2Parser(),
    ImageParser(),
    HeadingParser(),
    ButtonParser(),
  ];

  static final _widgetPraseMap = <String, WidgetParser>{};

  static bool _parseInit = false;

  static void init() {
    if (!_parseInit) {
      for (var parser in _parsers) {
        _widgetPraseMap[parser.widgetName] = parser;
      }
      _parseInit = true;
    }
  }

  static List<Widget> build(dynamic json, BuildContext buildContext) {
    if (json != null) {
      List<Widget> widgets = [];
      for (var obj in json) {
        Widget widget = buildFromMap(obj, buildContext);
        if (widget != null) {
          widgets.add(widget);
        }
      }
      //return widget;
      if (widgets.length > 0) {
        return widgets;
      }
    }
    return [
      Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('ไม่มีข้อมูล'),
      ),
    ];
  }

  static Widget buildContent(dynamic json, BuildContext buildContext) {
    init();
    log.i(json);
    if ((json != null) && (json[0] != null) && (json[0]['type'] == 'content')) {
      log.i(json[0]['data']['bg']['color']);
      var appbar = getInt(json[0]['data']['appbar']);
      var tabbar = getInt(json[0]['data']['tabbar']);

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

      return Container(
          decoration: BoxDecoration(
            gradient: getGradient(json[0]['data']['bg']['color']),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: (appbar == 1
                ? getAppbar(json[0]['child']['appbar'], buildContext)
                : null),
            body: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: getAlignMain(json[0]['data']['align']),
                children: build(json[0]['child']['body'], buildContext),
              ),
            ),
          ));
    }
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.0),
        child: Text('ไม่มีข้อมูล'),
      ),
    );
  }

  static Widget buildFromMap(
      Map<String, dynamic> map, BuildContext buildContext) {
    String widgetName = map['type'];
    var parser = _widgetPraseMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext);
    }
    log.w("Not support type: $widgetName");
    return null;
  }

  static List<Widget> buildWidgets(
      List<dynamic> values, BuildContext buildContext) {
    List<Widget> rt = [];
    for (var value in values) {
      rt.add(buildFromMap(value, buildContext));
    }
    return rt;
  }
}

abstract class WidgetParser {
  Widget parse(Map<String, dynamic> map, BuildContext buildContext);
  String get widgetName;
}
