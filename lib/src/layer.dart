import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'layer/detail.dart';
import 'layer/button.dart';
import 'layer/article.dart';
import 'convert/gradient.dart';
import 'convert/align.dart';
import 'convert/util.dart';
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
      dynamic json = Site.template[file];
      // เทมเพลทที่มีได้หลายแบบ ให้ใช้แบบแรกไปก่อน
      if(['article','articles','products','product'].contains(file)) {
        json = json[0];
      }
      if ((json is List) && (json[0] is Map) && (json[0]['type'] == 'content')) {
        dynamic box = getVal(json[0],'box'),
          child = getVal(json[0],'child'),
          data = getVal(json[0],'data');
        int appbar = getInt(getVal(data,'appbar')),
          navbar = getInt(getVal(data,'navbar'));
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        double offsetTop = 0, 
          offsetBottom = 0;
        AppBar _appbar = (appbar > 0 ? getAppBar(getVal(child,'appbar'), buildContext) : null);
        if(appbar == 2) {
          offsetTop = MediaQuery.of(buildContext).padding.top + _appbar.preferredSize.height + 5;
        }
        Widget _navbar = (navbar > 0 ? getNavBar(getVal(child,'navbar'), buildContext) : null);
        if(appbar == 2) {
          offsetBottom = getDouble(getVal(data,'bottom'));
        }
        return Container(        
            decoration: BoxDecoration(
              gradient: getGradient(getVal(box,'bg.color')),
            ),
            child: Scaffold(
              extendBody: navbar == 2,
              extendBodyBehindAppBar: appbar == 2,
              backgroundColor: Colors.transparent,
              appBar: _appbar,
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(top:offsetTop, bottom:offsetBottom),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: getAlignMain(getVal(data,'align')),
                      children: build(getVal(child,'body'), buildContext, par),
                    ),
                  ),
                )
              ),
              bottomNavigationBar: _navbar,
              resizeToAvoidBottomInset: true,
            ));
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้าเนื้อหาบทความ', 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 30),
        )
      )    
    );
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
