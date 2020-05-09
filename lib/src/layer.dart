import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifelse/src/convert/util.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'layer/appbar.dart';
import 'layer/navbar.dart';
import 'layer/split1.dart';
import 'layer/split2.dart';
import 'layer/split3.dart';
import 'layer/split4.dart';
import 'layer/split5.dart';
import 'layer/split6.dart';
import 'layer/image.dart';
import 'layer/heading.dart';
import 'layer/button.dart';
import 'layer/article.dart';
import 'convert/gradient.dart';
import 'convert/align.dart';
import 'site.dart';

class Layer {
  static final Logger log = Logger();
  static final _parsers = [
    Split1Parser(),
    Split2Parser(),
    Split3Parser(),
    Split4Parser(),
    Split5Parser(),
    Split6Parser(),
    ImageParser(),
    HeadingParser(),
    ButtonParser(),
    ArticleParser(),
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
      if (widgets.length > 0) {
        return widgets;
      }
    }
    return [
      Container(),
    ];
  }

  static Widget buildContent(dynamic json, BuildContext buildContext) {
    init();
    if ((json != null) && (json[0] != null) && (json[0]['type'] == 'content')) {
      dynamic box = getVal(json[0],'box'),
        child = getVal(json[0],'child'),
        data = getVal(json[0],'data');
      int appbar = getInt(getVal(data,'appbar')),
        navbar = getInt(getVal(data,'navbar'));

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

      return Container(
        
          decoration: BoxDecoration(
            gradient: getGradient(getVal(box,'bg.color')),
          ),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: (appbar == 1
                ? getAppBar(getVal(child,'appbar'), buildContext)
                : null),
            body: SingleChildScrollView(
              child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: getAlignMain(getVal(data,'align')),
                      children: build(getVal(child,'body'), buildContext),
                    ),
                  ),
              )
            ),
            bottomNavigationBar: (navbar == 1
                ? getNavBar(getVal(child,'navbar'), buildContext)
                : null),
          ));
    }
    return Container();
  }

  static Widget buildFromMap(
    Map<String, dynamic> map, BuildContext buildContext) {
    String widgetName = map['type'];
    var parser = _widgetPraseMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext);
    }
    log.w("Not support - $widgetName");
    return null;
  }
}

abstract class WidgetParser {
  Widget parse(Map<String, dynamic> map, BuildContext buildContext);
  String get widgetName;
}
