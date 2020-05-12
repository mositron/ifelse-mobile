import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'layer/split1.dart';
import 'layer/split2.dart';
import 'layer/split3.dart';
import 'layer/split4.dart';
import 'layer/split5.dart';
import 'layer/split6.dart';
import 'layer/image.dart';
import 'layer/heading.dart';
import 'layer/detail.dart';
import 'layer/button.dart';
import 'layer/article.dart';
import 'convert/util.dart';
import 'convert/align.dart';
import 'site.dart';
import 'page.dart';

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
    DetailParser(),
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

  static List<Widget> build(dynamic json, BuildContext buildContext, [Map<String, dynamic> par]) {
    if (json != null) {
      List<Widget> widgets = [];
      for (var obj in json) {
        Widget widget = buildFromMap(obj, buildContext, par);
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

  static Widget buildContent(String file, BuildContext buildContext, [Map<String, dynamic> par]) {
    init();
    if(Site.template[file] is List) {
      List page = Site.template[file];
      if(page.length > 0) {
        return PageWidget(file: file, par: par);
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 30),
        )
      )    
    );
  }

  static Widget buildBody(String file, BuildContext buildContext, [Map<String, dynamic> par]) {
    if(Site.template[file] is List) {
      List json = Site.template[file];
      if(json.length > 0) {
        dynamic json = Site.template[file];
        // เทมเพลทที่มีได้หลายแบบ ให้ใช้แบบแรกไปก่อน
        if(['article','articles','products','product'].contains(file)) {
          json = json[0];
        }
        if ((json is List) && (json[0] is Map) && (json[0]['type'] == 'content')) {
          dynamic child = getVal(json[0],'child'),
            data = getVal(json[0],'data');
          Site.log.i(getVal(child,'body'));
          return Column(
            mainAxisAlignment: getAlignMain(getVal(data,'align')),
            children: build(getVal(child,'body'), buildContext, par),
          );
        }
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 30),
        )
      )    
    );
  }

  static void navClick(selectedIndex) {
    Site.log.i(selectedIndex);
  }

  static Widget buildFromMap(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    String widgetName = map['type'];
    var parser = _widgetPraseMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext, par);
    }
    log.w("Not support - $widgetName");
    return null;
  }
}

abstract class WidgetParser {
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]);
  String get widgetName;
}
