import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/article.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ArticlePageWidget(buildContext: context, par: par));
  }
}

class ArticlePageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  final BuildContext buildContext;
  ArticlePageWidget({Key key, this.buildContext, this.par}) : super(key: key);
  @override
  _ArticlePageWidgetState createState() => _ArticlePageWidgetState(buildContext, par);
}

class _ArticlePageWidgetState extends State<ArticlePageWidget> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;

  _ArticlePageWidgetState(this.buildContext, this.par);
  
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
                : IfDialog.getLoading();
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
      return Layer.buildContent('article', buildContext, data);
    }
    return Container();
  }
}