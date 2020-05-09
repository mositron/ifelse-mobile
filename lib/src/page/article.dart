import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    Site.log.i(par);
    return MaterialApp(title: Site.name, home: ArticlePageWidget(par: par));
  }
}

class ArticlePageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  ArticlePageWidget({Key key, this.par}) : super(key: key);
  @override
  _ArticlePageWidgetState createState() => _ArticlePageWidgetState(par);
}

class _ArticlePageWidgetState extends State<ArticlePageWidget> with SingleTickerProviderStateMixin {
  TabController controller;
  Map<String, dynamic> par;
  _ArticlePageWidgetState(this.par);

  @override
  Widget build(BuildContext context) {    
    return Layer.buildContent(Site.template['article'],context, par);
  }
}