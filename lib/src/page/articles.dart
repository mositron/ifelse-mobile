import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class ArticlesPage extends StatelessWidget {
  ArticlesPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ArticlesPageWidget(buildContext: context, par: par), debugShowCheckedModeBanner:false);
  }
}

class ArticlesPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  final BuildContext buildContext;
  ArticlesPageWidget({Key key, this.buildContext, this.par}) : super(key: key);
  @override
  _ArticlesPageWidgetState createState() => _ArticlesPageWidgetState(buildContext, par);
}

class _ArticlesPageWidgetState extends State<ArticlesPageWidget> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;

  _ArticlesPageWidgetState(this.buildContext, this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      'category': par['category'] ?? '0',
      'status': '',
      'tag': '',
      'order': '',
      'skip': '0'
    };
    if(request['category'] != '0') {
      if((Site.articles is List) && (Site.articles.length > 0)) {
        Site.articles.forEach((v) {
          String _id = v['_id'].toString();
          if(_id == request['category']) {
            request['text'] = v['title'].toString();
          }
        });
      } else {
        request['text'] = '';
      }
    } else {
      request['text'] = 'บทความทั้งหมด';
    }
    return Layer.buildContent('articles', buildContext, request);
  }
}