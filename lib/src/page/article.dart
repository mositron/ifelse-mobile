import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/article.dart';
import '../convert/loading.dart';
import '../convert/util.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
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
  bool loaded;
  TabController controller;
  Map<String, dynamic> par;

  _ArticlePageWidgetState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    //Site.log.e('get article - ' + getVal(par, '_id').toString());
    int id = getInt(getVal(par, '_id'));
    if(id > 0) {
      return Container(
        color: Colors.transparent,
        child: FutureBuilder<Map>(
          future: Article.getArticle(id),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? getWidget(snapshot.data)
                    : Article.retryButton(fetch)
                : getLoading();
          }
        )
      );
    } else {
      //throw Exception("Invalid ID.\nPlease Retry");
      return Container();
    }
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }

  Widget getWidget(dynamic data) {
    if(data is Map) {
      return Layer.buildContent('article',context, data);
    }
    return Container();
  }
}