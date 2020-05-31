import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/article.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  State<StatefulWidget> createState() {
    return ArticleState(par);
  }
}

class ArticleState extends State<ArticlePage> {
  bool loaded;
  Map<String, dynamic> par;
  ArticleState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        int id = getInt(getVal(par, '_id'));
        if(id > 0) {
          return FutureBuilder<Map>(
            future: Article.getArticle(id),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                  ? getWidget(context, snapshot.data)
                  : Article.retryButton(fetch)
                : IfDialog.getLoading();
            }
          );
        } else {
          return Container();
        }
      }
    );
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }

  Widget getWidget(BuildContext context, dynamic data) {
    if(data is Map) {
      return Layer.buildContent('article', context, data);
    }
    return Container();
  }
}