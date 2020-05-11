import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/gradient.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/article.dart';
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
    int id = getInt(getVal(par, '_id'));
    if(id > 0) {
      return FutureBuilder<Map>(
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
                  ),
                ) ;
        },
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
    /*
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ไม่สามารถดึงข้อมูลได้', 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 24),
        )
      )    
    );*/
  }
}