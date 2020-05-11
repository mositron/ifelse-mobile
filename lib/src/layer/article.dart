import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../layer.dart';
import '../page/article.dart';
import '../convert/article.dart';
import '../convert/util.dart';

class ArticleParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    return ArticleView(map, par);    
  }
  @override
  String get widgetName => 'article';
}

class ArticleView extends StatefulWidget {
  final dynamic _map;
  final dynamic _par;
  ArticleView(this._map, this._par);
  @override
  _ArticleViewState createState() => _ArticleViewState(_map, _par);
}
 
class _ArticleViewState extends State<ArticleView> {
  bool isHomeDataLoading;
  dynamic _map;
  dynamic _par;
  _ArticleViewState(this._map, this._par);

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
          future: Article.getList(_map),
          builder: (context, snapshot) {
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