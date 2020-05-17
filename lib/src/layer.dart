import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'site.dart';
import 'page.dart';
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
import 'layer/product.dart';
import 'layer/job.dart';
import 'layer/space.dart';
import 'layer/divider.dart';
import 'layer/gallery.dart';
import 'layer/picture.dart';
import 'layer/price.dart';
import 'layer/request.dart';
import 'layer/description.dart';
import 'convert/util.dart';

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
    ProductParser(),
    JobParser(),
    SpaceParser(),
    DividerParser(),
    GalleryParser(),
    PriceParser(),
    PictureParser(),
    RequestParser(),
    DescriptionParser(),
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

  static List<Widget> build(String file, dynamic json, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    if (json != null) {
      List<Widget> widgets = [];
      for (var obj in json) {
        Widget widget = buildFromMap(file, obj, buildContext, par, func);
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

  static Widget buildContent(String file, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    init();
    if(Site.template[file] is List) {
      List page = Site.template[file];
      if(page.length > 0) {
        return PageWidget(file: file, par: par, func: func);
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า 2 - '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 30),
        )
      )    
    );
  }

  static Widget buildBody(String file, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    if(Site.template[file] is List) {
      List json = Site.template[file];
      if(json.length > 0) {
        dynamic json = Site.template[file];
        // เทมเพลทที่มีได้หลายแบบ ให้ใช้แบบแรกไปก่อน
        if(['article','articles','products','product'].contains(file)) {
          json = json[0];
        }
        if ((json is List) && (json[0] is Map) && (json[0]['type'] == 'content')) {
          dynamic child = getVal(json[0],'child');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center, // getAlignMain(getVal(data,'align')),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: build(file, getVal(child,'body'), buildContext, par, func),
          );
        }
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า 4 - '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 30),
        )
      )    
    );
  }

  static void navClick(selectedIndex) {
    Site.log.i(selectedIndex);
  }

  static Widget buildFromMap(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    String widgetName = map['type'];
    var parser = _widgetPraseMap[widgetName];
    if (parser != null) {
      if(file == 'login') {
        Site.log.i(func);
        Site.log.i(widgetName);
      }

      return parser.parse(file, map, buildContext, par, func);
    }
    log.w("Not support - $widgetName");
    return null;
  }
}

abstract class WidgetParser {
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]);
  String get widgetName;
}
