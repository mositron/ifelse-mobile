import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class ArticlesPage extends StatefulWidget {
  ArticlesPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  State<StatefulWidget> createState() {
    return ArticlesState(par);
  }
}

class ArticlesState extends State<ArticlesPage> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;
  ArticlesState(this.par);
  
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
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        return Layer.buildContent('articles', buildContext, request);
      }
    );
  }
}