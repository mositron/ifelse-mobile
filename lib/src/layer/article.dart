import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ifelse/src/page/article.dart';
import '../layer.dart';
import '../convert/article.dart';
import '../convert/util.dart';

class ArticleParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext) {
    return ArticleView(map);    
  }
  @override
  String get widgetName => 'article';
}

class ArticleView extends StatefulWidget {
  final dynamic _map;
  ArticleView(this._map);
  @override
  _ArticleViewState createState() => _ArticleViewState(_map);
}
 
class _ArticleViewState extends State<ArticleView> {
  bool isHomeDataLoading;
  dynamic _map;
  
  _ArticleViewState(this._map) {
    //Site.log.w(_map);
  }

  @override
  void initState() {
    super.initState();
    //Site.log.w(_map);
    isHomeDataLoading = false;
  }
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: FutureBuilder<List<CellModel>>(
          future: Article.getData(_map),
          builder: (context, snapshot) {            
            //Site.log.e(_map);
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? Article.getGrid(snapshot, _map, gridClicked)
                    : Article.retryButton(fetch)
                : Article.circularProgress();
          },
        ),
      ),
    );
  }
 
  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }
}
 
gridClicked(BuildContext context, CellModel cellModel) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage(par:{'_id':getInt(cellModel.id,0)})));
}