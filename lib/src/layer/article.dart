import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../layer.dart';
import '../site.dart';
import '../page/article.dart';
import '../convert/article.dart';
import '../convert/util.dart';

class ArticleParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    return new ArticleView(key: UniqueKey(), map: map, buildContext: buildContext, par: par);    
  }
  
  @override
  String get widgetName => 'article';
}

class ArticleView extends StatefulWidget {
  final dynamic map;
  final BuildContext buildContext;
  final dynamic par;
  ArticleView({Key key, this.map, this.buildContext, this.par}) : super(key: key);

  @override
  _ArticleViewState createState() {
    //Site.log.w(_map);
    return new _ArticleViewState(map, par);
  }
}
 
class _ArticleViewState extends State<ArticleView> {
  bool loaded;
  dynamic _map;
  dynamic _par;
  _ArticleViewState(this._map, this._par) {
    //Site.log.w(_map);

  }

  @override
  void initState() {
    super.initState();
    //Site.log.w(' ---- state ---------------');
    loaded = false;
  }
 
  @override
  Widget build(BuildContext context) {    
    dynamic data = getVal(_map,'data');
    String spec = getVal(_map,'spec').toString();
    Map<String,String> request = {};
    request['limit'] = getVal(data,'limit').toString();
    request['category'] = '';
    if(spec == 'auto') {
      List category = getVal(_par,'category');
      if((category is List) && (category.length > 0)) {
        request['category'] = category.join(',');
      }
      request['status'] = getVal(_par,'staus') ?? '';
      request['tag'] = getVal(_par,'tag') ?? '';
      request['order'] = getVal(_par,'order') ?? '';
      request['skip'] = '0';
    } else {
      List category = getVal(data,'category');
      if((category is List) && (category.length > 0)) {
        request['category'] = category.join(',');
      }
      request['status'] = getVal(data,'staus') ?? '';
      request['tag'] = getVal(data,'tag') ?? '';
      request['order'] = getVal(data,'order') ?? '';
      request['skip'] = getVal(data,'skip') ?? '';
    }

    return Center(
      child: Container(
        child: FutureBuilder<List<CellModel>>(
          future: Article.getList(request),
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
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }
}
 
gridClicked(BuildContext context, CellModel cellModel) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage(par:{'_id':getInt(cellModel.id,0)})));
}