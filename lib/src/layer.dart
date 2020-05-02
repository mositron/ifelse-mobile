library layer;

import 'layer/split1.dart';
import 'layer/image.dart';
import 'layer/heading.dart';
import 'layer/button.dart';
import 'convert/gradient.dart';
import 'convert/align.dart';

import 'package:flutter/material.dart';


import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';


class Layer {
  static final Logger log = Logger();

  static final _parsers = [
    Split1Parser(),
    ImageParser(),
    HeadingParser(),
    ButtonParser(),

  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};

  static bool _defaultParserInited = false;

  static void init() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static List<Widget> build(dynamic json, BuildContext buildContext) {
    if(json != null) {
      List<Widget> rt = [];
      for (var value in json) {
        rt.add(buildFromMap(value, buildContext));
      }
      //return widget;
      return rt;
    }
    return [Container()];
  }

  static Widget buildContent(dynamic json, BuildContext buildContext) {
    init();
    //log.i(json);
    if((json != null) && (json[0] != null) && (json[0]['type'] == 'content')) {
      //log.w(getAlignMain(json[0]['data']['align']));
      return Scaffold(
        appBar: AppBar(
          title: Text('zz'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: getGradient(json[0]['data']['bg']['color']),
          ),
          //getAlignContent(json[0]['data']['align'])
          //alignment: Alignment.bottomLeft,
          
          child: Column(
            mainAxisAlignment: getAlignMain(json[0]['data']['align']),
            children: build(json[0]['child'][1], buildContext),
          ),
        ),
      );

    }
    //var map = jsonDecode(json);
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('ไม่มีข้อมูล'),
      ),
    );
  }

  static Widget buildFromMap(Map<String, dynamic> map, BuildContext buildContext) {
    String widgetName = map['type'];
    var parser = _widgetNameParserMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext);
    }
    log.w("Not support type: $widgetName");
    return null;
  }

  static List<Widget> buildWidgets( List<dynamic> values, BuildContext buildContext) {
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