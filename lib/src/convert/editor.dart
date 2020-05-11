import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'util.dart';
import '../convert/image.dart';

List<Widget> getEditor(dynamic data) {
  List<Widget> widget = [];
  if ((data is Map) && (data['blocks'] is List)) {
    data['blocks'].forEach((v){
      switch(v['type']) {
        case 'paragraph':
          widget.add(editorParagraph(v));
          break;
        case 'heading':
        case 'header':
          widget.add(editorHeading(v));
          break;
        case 'image':
          widget.add(editorImage(v));
          break;
        case 'list':
          widget.add(editorList(v));
          break;
        case 'delimiter':
        case 'embed':
        case 'table':
        case 'code':
        case 'youtube':
        case 'divider':
      }
    });
  }
  return widget;
}
Widget _parse(String html,double fontSize) {
  return Html(
    data: html,
    customTextStyle: (dom.Node node, TextStyle baseStyle) {
      return baseStyle.merge(TextStyle(fontSize: fontSize, fontFamily:'Kanit'));
    },
    linkStyle: TextStyle(
      decoration: TextDecoration.underline,
    ),
    onLinkTap: (url) => _launchURL(url),
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget editorParagraph(Map block) {
  return Container(
    margin: EdgeInsets.only(bottom:15),
    alignment: Alignment.centerLeft,
    child: _parse(block['data']['text'], 16)
  );
}

Widget editorHeading(Map block) {
  Map<int,double> size = {0:16,1:40,2:32,3:28,4:24,5:20,6:16};
  return Container(
    margin: EdgeInsets.only(bottom:10),
    alignment: Alignment.centerLeft,
    child: _parse(block['data']['text'], size[getInt(getVal(block,'data.level')??0)])
  );
}

Widget editorImage(Map block) {
  Map image = getImageObj(getVal(block,'data.image'),'o');
  return Container(
    margin: EdgeInsets.only(bottom:15),
    alignment: Alignment.centerLeft,
      child: image != null ? 
        getImageWidget(image['src']) : 
        null,
  );
}

Widget editorList(Map block) {
  List<Widget> list = [];

  List<dynamic> tmp = getVal(block,'data.items');
  String style = getVal(block,'data.style').toString();
  if(tmp is List) {
    for(int i=0; i<tmp.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.only(bottom:5),
          alignment: Alignment.centerLeft,
          child: _parse((style == 'unordered' ? '●' : (i+1).toString()) + ' ' + tmp[i], 16)
        )
      );
    }
  }
  return Container(
    margin: EdgeInsets.only(bottom:10),
    padding: EdgeInsets.only(left:20),
    alignment: Alignment.centerLeft,
    child: Column(
      children: list
    )
  );
}
