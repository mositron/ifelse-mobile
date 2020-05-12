import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/article.dart';
import '../convert/gradient.dart';
import '../convert/util.dart';

class ArticlesPage extends StatelessWidget {
  ArticlesPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ArticlesPageWidget(par: par));
  }
}

class ArticlesPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  ArticlesPageWidget({Key key, this.par}) : super(key: key);
  @override
  _ArticlesPageWidgetState createState() => _ArticlesPageWidgetState(par);
}

class _ArticlesPageWidgetState extends State<ArticlesPageWidget> with SingleTickerProviderStateMixin {
  bool loaded;
  TabController controller;
  Map<String, dynamic> par;

  _ArticlesPageWidgetState(this.par);
  
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
                : Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              gradient: getGradient({'color1':'fff','color2':'fff','range':1,'gragient':2}),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),                      
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                            ),
                          ),
                      )
                    )
                  );
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
      return Layer.buildContent('articles',context, data);
    }
    return Container();
  }
}